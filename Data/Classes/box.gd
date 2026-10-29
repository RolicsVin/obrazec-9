class_name Box extends RigidBody3D

var start_pos: Vector3


func _ready() -> void:
	start_pos = position
	axis_lock_angular_x = true
	axis_lock_angular_y = true


func _physics_process(delta: float) -> void:
	position.z = 0
	
	if position.y <= -10:
		position = start_pos


func dead():
	position = start_pos


func kill():
	position = start_pos


func damage():
	position = start_pos
