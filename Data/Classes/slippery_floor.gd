class_name SlipperyFloor extends Area3D

@export var is_active: bool = true

@export var player_jump_force: float = 7.0
@export var player_friction: float = 0.2


func _ready() -> void:
	body_entered.connect(on_entered)
	body_exited.connect(on_exited)


func on():
	is_active = true


func off():
	is_active = false


func on_entered(body: Node3D):
	if not is_active:
		return
	if not body is Player:
		return
	body.friction = player_friction
	body.jump_force = player_jump_force


func on_exited(body: Node3D):
	if not is_active:
		return
	if not body is Player:
		return
	body.friction = 5.0
	body.jump_force = 10.0
