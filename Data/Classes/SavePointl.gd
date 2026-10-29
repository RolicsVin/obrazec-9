class_name SavePoint extends Area3D


func _ready() -> void:
	body_entered.connect(on_player_enter)


func on_player_enter(body: Node3D):
	if body.is_in_group('Player'):
		body.save_point = position
