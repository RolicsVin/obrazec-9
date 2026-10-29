extends Node


var _view: bool = false
@onready var player: Player = $"../Player"
var camera: Camera3D
var start_pos: Vector3
var a: bool = false

func view(_body):
	if _view:
		return
	_view = true
	camera = player.get_camera()
	start_pos = camera.global_position
	player.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(5).timeout
	$"../Components/Door2".on()


func _process(delta: float) -> void:
	if camera:
		if a:
			camera.global_position = GodoTools.move_toward_3d(camera.global_position, start_pos, 10 * delta)
			if camera.global_position == start_pos:
				camera = null
				player.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			camera.global_position = GodoTools.move_toward_3d(camera.global_position, $"../Node3D".position, 10 * delta)
			if $"../Components/Door2".is_on:
				await get_tree().create_timer(3).timeout
				a = true
