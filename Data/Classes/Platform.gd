class_name Platform extends StaticBody3D

@export var is_moving: bool = false
@export var moving_points: Array
@export var speed: float = 0.5
var element: Node3D
var num: int = 0


func _ready() -> void:
	if is_moving:
		var arr = []
		for i in moving_points:
			arr.append(get_tree().root.get_node('Level').get_node('Components').get_node(i))
		moving_points = arr
		element = moving_points[num]
		_element()


func _physics_process(delta: float) -> void:
	if not is_moving: return
	position.x = move_toward(position.x, element.position.x, speed * delta)
	position.y = move_toward(position.y, element.position.y, speed * delta)


func _element():
	if position == element.position:
		num += 1
		if num > len(moving_points) - 1:
			num = 0
		element = moving_points[num]
	await get_tree().create_timer(1).timeout
	_element()
