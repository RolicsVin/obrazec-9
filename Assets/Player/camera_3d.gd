extends Camera3D

## Локальное смещение камеры относительно игрока
@export var target_offset: Vector3 = Vector3(0.0, 3.5, 8.0)

## Скорость обычного следования
@export var follow_speed: float = 6.0

## Насколько камера будет отставать при ускорении
@export var velocity_influence: float = 0.18

var player: Player


func _ready():
	player = get_parent() as Player
	position = target_offset


func _process(delta):
	if player == null:
		return
	if not player.camera_smooth:
		return

	# Чем быстрее движется игрок, тем сильнее камера немного отстаёт.
	var lag = -player.linear_velocity * velocity_influence

	# В 2.5D нам не нужно реагировать на Z
	lag.z = 0
	var desired = target_offset + lag
	position.x = lerp(position.x, desired.x, 1.0 - exp(-follow_speed * delta))
	position.y = lerp(position.y, desired.y, 1.0 - exp(-2.5 * delta))
	position.z = lerp(position.z, desired.z, 1.0 - exp(-follow_speed * delta))
