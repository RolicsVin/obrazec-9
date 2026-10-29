class_name ButtonAreaSpecial extends Area3D

@export var timer: Timer
@export var connected: Node3D
@export var invert: bool
@export var is_fly: bool
@onready var player = get_tree().get_nodes_in_group('Player')[0]
var is_player_on_area: bool = false
var is_presed: bool = false


func _ready() -> void:
	body_entered.connect(on_body_enter)
	body_exited.connect(on_body_exit)
	if invert:
		connected.on()
		is_presed = true
		return
	connected.off()


func _physics_process(_delta: float) -> void:
	if not is_player_on_area:
		return
	if Input.is_action_just_pressed('accert'):
		on_pressed()


func on_body_enter(body: Node3D):
	if body.is_in_group('Player'):
		is_player_on_area = true


func on_body_exit(body: Node3D):
	if body.is_in_group('Player'):
		is_player_on_area = false


func on_pressed():
	print('321')
	if not timer.is_stopped():
		return
	is_presed = not is_presed
	if is_presed:
		connected.on()
		player.is_fly = is_fly
	else:
		connected.off()
		player.is_fly = false
	timer.start()
