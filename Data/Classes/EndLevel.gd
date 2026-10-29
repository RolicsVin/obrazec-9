class_name EndLevel extends Area3D

var player
var pos


func _ready() -> void:
	body_entered.connect(on_player_enter)


func _physics_process(delta: float) -> void:
	if player:
		player.position = pos


func on_player_enter(body: Node3D):
	if body.is_in_group('Player'):
		player = body
		player.camera_smooth = false
		pos = body.position
		
		var num: int = Data.levels_paths[$"../../Path".path]
		
		if num > Data.levels:
			Data.levels = num
			Data.save()
			print(num)
			print(Data.levels)
		
		$"../../Logo".end()
		await get_tree().create_timer(0.5).timeout
		
		if (Data.levels_paths[$"../../Path".path] + 1) <= Data.max_levels:
			get_tree().change_scene_to_file(Data.levels_paths_inverse[Data.levels_paths[$"../../Path".path] + 1])
		else:
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
