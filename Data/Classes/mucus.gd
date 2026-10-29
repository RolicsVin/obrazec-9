class_name Mucus extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_enter)
	body_exited.connect(_on_body_exit)


func _on_body_enter(body: Node3D):
	if body.is_in_group('Player'):
		body.gravity_scale = 0.1


func _on_body_exit(body: Node3D):
	if body.is_in_group('Player'):
		body.gravity_scale = 2
