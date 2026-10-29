extends Area3D

var dir: Vector3


func  _physics_process(delta: float) -> void:
	position += dir * delta


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		body.dead()
	get_parent().queue_free()
