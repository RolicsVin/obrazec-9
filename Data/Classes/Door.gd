class_name Door extends StaticBody3D

@export var anim: AnimationPlayer
@export var blend: float = 0.8
var is_on: bool = false


func on():
	is_on = true
	anim.play('on', blend)


func off():
	is_on = false
	anim.play('off', blend)
