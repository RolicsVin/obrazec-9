extends Control

var is_load: bool = false

var counter: int = 0


func _ready() -> void:
	await get_tree().create_timer(20).timeout
	if GodoTools.is_mobile():
		$Label.text = 'Нажмите несколько раз, чтобы пропустить заставку'
	if not is_load:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		counter += 1
	
	
	if Input.is_action_just_pressed("ui_cancel") or counter >= 3:
		is_load = true
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
