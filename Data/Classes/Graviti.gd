class_name Gravity extends Area3D

const wait_time = 0.1
@onready var player = get_tree().get_nodes_in_group('Player')[0]
var is_swith: bool = false


func _ready() -> void:
	body_entered.connect(swith_gravity)


func swith_gravity(body: Node3D):
	if body.is_in_group('Player'):
		body.gravity_reverse()


func on():
	if is_swith: return
	swith_gravity(player)
	is_swith = true
	await get_tree().create_timer(wait_time).timeout
	is_swith = false


func off():
	if is_swith: return
	swith_gravity(player)
	is_swith = true
	await get_tree().create_timer(wait_time).timeout
	is_swith = false
