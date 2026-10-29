class_name GravityArea extends Area3D

@export var attraction_force: float = 10.0

var bodies: Array[RigidBody3D] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(_delta: float) -> void:
	for body in bodies:
		if is_instance_valid(body):
			var direction := global_position.direction_to(body.global_position)
			var distance := global_position.distance_to(body.global_position)

			# Не даём силе стать бесконечной в центре
			if distance > 0.1:
				body.apply_central_force(-direction * attraction_force)


func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		bodies.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		bodies.erase(body)
