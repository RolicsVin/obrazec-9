class_name Ships extends Node3D

@export var animation_player: AnimationPlayer
var is_on = true


func _on_player_entered(player: Node3D):
	if not is_on: return
	if player.is_in_group('Player'):
		player.dead()


func on():
	animation_player.play('on')
	is_on = true


func off():
	animation_player.play('off')
	is_on = false
