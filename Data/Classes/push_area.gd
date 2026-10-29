class_name PushArea extends Area3D

@export var material: StandardMaterial3D
@export var mesh: MeshInstance3D
@export var boom: GPUParticles3D

@export var gravity_reverse: bool = false

@export_group("Push")
@export var push_direction: Vector3 = Vector3.UP
@export var push_force: float = 10.0

@export_group("Cooldown")
@export var cooldown_time: float = 0.5
var cooldown: float = 0.0

@export_group("Input")
@export var click_memory_time: float = 0.2


var player: Player = null

# Сколько времени ещё хранится нажатие E.
var click_memory: float = 0.0
var is_clicked: float = 0.0


func _ready():
	if material:
		mesh.set_surface_override_material(1, material)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(delta):
	# Запоминаем нажатие
	if Input.is_action_pressed("push") and cooldown <= 0.0:
		click_memory = click_memory_time
	
	# Уменьшаем память нажатия
	if click_memory > 0.0:
		click_memory -= delta
	
	# Уменьшаем кулдаун
	if cooldown > 0.0:
		cooldown -= delta
	
	# Срабатывание
	if player and click_memory > 0.0 and cooldown <= 0.0:
		push_player()
	
		click_memory = 0.0
		cooldown = cooldown_time


func push_player():
	if boom:
		boom.emitting = true
	
	var direction := push_direction.normalized()
	
	player.apply_central_impulse(direction * push_force)
	
	if gravity_reverse:
		player.gravity_reverse()


func _on_body_entered(body: Node3D):
	if body is Player:
		player = body


func _on_body_exited(body: Node3D):
	if body == player:
		player = null
