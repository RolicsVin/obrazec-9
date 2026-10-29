extends Node

const save_path: String = 'user://'


var _buffer: Dictionary = {}



func _get_obj_on_buffer(k):
	"""Вернёт объект из буфера по ключу."""
	return _buffer[k]


func _get_buffer() -> Dictionary:
	"""Вернёт буффер модуля godo_visual_novel."""
	return _buffer


func _write_buffer(obj, k) -> void:
	"""Допишет в буфер информацию по ключу. Если ключ уже существует, то информация будет перезаписана."""
	_buffer[k] = obj


func push_fatal_error(message: String):
	"""Выведет сообщение об ошибке, через print и push_error. После вывода ошибки обрушит проект."""
	print('Печатает служба Godo Tools')
	print(message)
	push_error(message)
	await get_tree().create_timer(0.1).timeout
	Engine.get_main_loop().quit()


func is_mobile() -> bool:
	var _is_mobile = false
	_is_mobile = OS.get_name() in ["Android", "iOS"]
	_is_mobile = "Android".to_lower() in OS.get_name().to_lower()
	_is_mobile = "iOS".to_lower() in OS.get_name().to_lower()
	
	return _is_mobile


func is_android() -> bool:
	return OS.get_name() == "Android"


func is_ios() -> bool:
	return OS.get_name() == "iOS"


func chance(percent: float) -> bool:
	"""Вернёт true с заданной вероятностью, иначе false"""
	return randf() * 100.0 < percent


func get_scene_path() -> String:
	"""Выдаст путь до текущей сцены."""
	return get_tree().current_scene.scene_file_path


func _reload_current_scene() -> void:
	"""Перезапустит текущую сцену."""
	get_tree().change_scene_to_file(get_scene_path())


func take_screenshot() -> Image:
	"""Вернёт скриншот экрана(Image)."""
	var screenshot = get_viewport().get_texture().get_image()
	return screenshot


func get_screen_size() -> Vector2:
	return DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())


func change_scene(scene_file: String):
	"""Сменит сцену и автоматом сделает красивый переход."""
	var preload_visible_scene = preload("res://GodoTools/tools/visible_scene.tscn")
	var visible_scene = preload_visible_scene.instantiate()
	visible_scene.hidding = false
	get_tree().current_scene.add_child(visible_scene)
	
	await get_tree().create_timer(3).timeout
	
	get_tree().change_scene_to_file(scene_file)


func exit_game() -> void:
	"""Завершит игру."""
	var preload_visible_scene = preload("res://GodoTools/tools/visible_scene.tscn")
	var visible_scene = preload_visible_scene.instantiate()
	visible_scene.hidding = false
	get_tree().current_scene.add_child(visible_scene)
	
	await get_tree().create_timer(3).timeout
	
	get_tree().quit()


func change_scene_with_loading_screen(scene_file: String, time: float = 0.0):
	"""Сменит сцену и автоматом сделает красивый переход."""
	if not time:
		time = Array(range(5, 8)).pick_random()
	
	var preload_visible_scene = preload("res://GodoTools/tools/visible_scene.tscn")
	var visible_scene = preload_visible_scene.instantiate()
	visible_scene.hidding = false
	
	get_tree().change_scene_to_file("res://GodoTools/tools/loading_screen.tscn")
	
	await get_tree().create_timer(time + Array(range(-2, 2)).pick_random()).timeout
	
	get_tree().current_scene.add_child(visible_scene)
	
	await get_tree().create_timer(1.1).timeout
	
	get_tree().change_scene_to_file(scene_file)


func read_lines(path: String) -> Array[String]:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return []
	
	var lines: Array[String] = []
	
	while not file.eof_reached():
		lines.append(file.get_line())
	
	return lines


func get_save() -> Dictionary:
	"""Вернёт сохранение"""
	var save: Dictionary = {
		'characters': GtData.data[GtEnums.sound_type.CHARACTER],
		'sounds': GtData.data[GtEnums.sound_type.SOUND],
		'musics': GtData.data[GtEnums.sound_type.MUSIC],
		'other': GtData.data[GtEnums.sound_type.OTHER],
		'brightness': _buffer['brightness'],
		'contrast': _buffer['contrast'],
		'saturation': _buffer['saturation'],
		'noise_intensity': _buffer['noise_intensity']
	}
	print()
	print('Печатает служба Godo Tools')
	print('GTsave---------------------------------------')
	print(save)
	print('---------------------------------------------')
	print()
	return save


func load_save(save: Dictionary):
	"""Загрузит сохранение"""
	GtData.data[GtEnums.sound_type.CHARACTER] = save['characters']
	GtData.data[GtEnums.sound_type.SOUND] = save['sounds']
	GtData.data[GtEnums.sound_type.MUSIC] = save['musics']
	GtData.data[GtEnums.sound_type.OTHER] = save['other']
	
	_buffer['brightness'] = save['brightness']
	_buffer['contrast'] = save['contrast']
	_buffer['saturation'] = save['saturation']
	_buffer['noise_intensity'] = save['noise_intensity']
	
	
	print()
	print('Печатает служба Godo Tools')
	print('GTsave_load---------------------------------------')
	print(save)
	print('---------------------------------------------')
	print()



func get_date() -> String:
	var date = Time.get_datetime_dict_from_system()
	return "%02d.%02d.%04d" % [date.day, date.month, date.year]


func get_time() -> String:
	var time = Time.get_datetime_dict_from_system()
	return "%02d:%02d:%02d" % [time.hour, time.minute, time.second]


func move_toward_2d(from: Vector2, to: Vector2, delta: float) -> Vector2:
	var distance := from.distance_to(to)
	
	if distance <= delta:
		return to
	
	return from + from.direction_to(to) * delta


func move_toward_3d(from: Vector3, to: Vector3, delta: float) -> Vector3:
	var distance := from.distance_to(to)
	
	if distance <= delta:
		return to
	
	return from + from.direction_to(to) * delta
