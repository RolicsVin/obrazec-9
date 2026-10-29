class_name AtmosphereSounds extends Node

@export var current: AudioStreamPlayer
var swith_speed = 0.05


func _ready() -> void:
	if current:
		current.play()


func play(musc: String):
	for child: AudioStreamPlayer in get_children():
		if child.name == musc:
			current = child
			current.play()


func _physics_process(delta: float) -> void:
	for child: AudioStreamPlayer in get_children():
		if child == current:
			child.volume_db = clamp(child.volume_db + swith_speed, -50, 0)
		else:
			child.volume_db = clamp(child.volume_db - swith_speed, -50, 0)
