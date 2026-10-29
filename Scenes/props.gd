extends Node


func _ready() -> void:
	if not Data.props:
		queue_free()
