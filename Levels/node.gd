extends Node

var y = 1.0
var z = 7.0

var _y = 1.0
var _z = 7.0

var r1 = false
var r2 = false


func _ready() -> void:
	$"../AtmosphereSounds".play('empty')


func _on_save_point_5_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		if r1:
			return
		r1 = true
		$"../AtmosphereSounds".play('music')
		$"../Components/AnimationPlayer".play("start_chalange")
		_y = 2.0
		_z = 14.0


func _physics_process(delta: float) -> void:
	y = move_toward(y, _y, 0.5)
	z = move_toward(z, _z, 0.5)
	var dir = Vector3(0.0, y, z)
	$"../Player".camera_offset(dir)


func _on_save_point_7_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		$"../Components/AnimationPlayer2".play("chalange2")


func _on_sun_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		if r2:
			return
		r2 = true
		$"../Light/DirectionalLight3D/AnimationPlayer".play("sun")
		_y = 1.0
		_z = 7.0
		await get_tree().create_timer(11).timeout
		$"../AtmosphereSounds".play('EndMusic')
