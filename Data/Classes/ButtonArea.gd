class_name ButtonArea extends Area3D


signal pressed(body: Node3D)
signal unpressed(body: Node3D)

@export var connected: Node3D
@export var invert: bool
@export var is_fly: bool
@export var mesh: MeshInstance3D
@export var material: StandardMaterial3D
@onready var player = get_tree().get_nodes_in_group('Player')[0]


func _ready() -> void:
	if material:
		mesh.set_surface_override_material(0, material)
	body_entered.connect(on_body_enter)
	body_exited.connect(on_body_exit)
	area_entered.connect(on_body_enter)
	area_exited.connect(on_body_exit)
	if invert:
		connected.on()
		return
	if connected:
		connected.off()


func on_body_enter(body: Node3D):
	if body.is_in_group('Player') or body.is_in_group('Box') or body is ColissionArea3D:
		pressed.emit(body)
		if invert:
			if connected:
				connected.off()
			player.is_fly = false
		else:
			if connected:
				connected.on()
			player.is_fly = is_fly


func on_body_exit(body: Node3D):
	if body.is_in_group('Player') or body.is_in_group('Box') or body is ColissionArea3D:
		unpressed.emit(body)
		if invert:
			if connected:
				connected.on()
			player.is_fly = is_fly
		else:
			if connected:
				connected.off()
			player.is_fly = false
