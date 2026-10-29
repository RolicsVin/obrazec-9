extends HBoxContainer


func _ready() -> void:
	for i in range(Data.health):
		var element = ColorRect.new()
		element.custom_minimum_size = Vector2(50, 50)
		add_child(element)
