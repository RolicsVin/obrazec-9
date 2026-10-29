class_name KillPart extends Area3D


func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node3D):
	if body.has_method('dead'):
		body.dead()
