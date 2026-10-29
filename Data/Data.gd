extends Node

# глобальные константы
const settings_path: String = 'user://settings.save'
const saves_path: String = 'user://saves.save'
const levels_paths: Dictionary = {
	"res://Levels/level1.tscn": 1,
	"res://Levels/level2.tscn": 2,
	"res://Levels/level3.tscn": 3,
	"res://Levels/level4.tscn": 4,
	"res://Levels/level5.tscn": 5,
	"res://Levels/level6.tscn": 6,
	"res://Levels/level7.tscn": 7,
	"res://Levels/level8.tscn": 8,
	"res://Levels/level9.tscn": 9,
	"res://Levels/level10.tscn": 10,
}
const levels_paths_inverse: Dictionary = {
	1: "res://Levels/level1.tscn",
	2: "res://Levels/level2.tscn",
	3: "res://Levels/level3.tscn",
	4: "res://Levels/level4.tscn",
	5: "res://Levels/level5.tscn",
	6: "res://Levels/level6.tscn",
	7: "res://Levels/level7.tscn",
	8: "res://Levels/level8.tscn",
	9: "res://Levels/level9.tscn",
	10: "res://Levels/level10.tscn",
}

# настройки геймплея
var camera_smooth: bool = true

# настройки графики
var ssr: bool = true
var ssao: bool = true
var ssil: bool = true
var sdfgi: int = 2 # 0 - отключен, 1 - включен(низкое качество), 2 - включен(высокое качество). Под качеством подразумеваеться параметр min_cell_size
var glow: bool = true
var volumetric_fog = true

var props: bool = true

var shadow: int = 2 # 0 - грубый фильтр теней(hard), 1 - обычные тени (soft low), 2 - качественные тени (soft ultra)
var msaa: String = '8x' # может быть: 'disabled', '2x', '4x', '8x'

# настройки масштабирования
var scale3d_mode: String = 'linear' # мождет быть 'linear' или 'FSR2'
var scale3d: float = 1.0 # масштаб

# сохранения пройденных уровней
var levels: int = 0
const max_levels: int = 7


# сохранение и загрузка
func save() -> void:
	var data := {}
	
	for property in get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			data[property.name] = get(property.name)
	
	var file := FileAccess.open(saves_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()


func load_save() -> void:
	print('Загрузка сейва...')
	
	if not FileAccess.file_exists(saves_path):
		if GodoTools.is_mobile():
			ssr = false
			ssao = false
			ssil = false
			sdfgi = 0
			glow = false
			volumetric_fog = false
			shadow = 0
			msaa = 'disabled'
			scale3d = 0.7
		
		save()
		return
	
	var file := FileAccess.open(saves_path, FileAccess.READ)
	var data: Dictionary = file.get_var()
	file.close()
	
	print(data)
	
	for key in data:
		if key in self:
			set(key, data[key])
