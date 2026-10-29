class_name Wind extends Area3D

@export var direction: Vector3 = Vector3(1, 0, 0):
	set(value):
		direction = value.normalized()

@export_range(0.0, 100.0, 0.1) var force: float = 10.0
@export var onn: bool = true


func _physics_process(_delta: float) -> void:
	if not onn:
		return
	
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			body.apply_central_force(direction * force)


func on():
	onn = true


func off():
	onn = false
