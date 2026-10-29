extends Control

var is_active: bool = true


func _ready() -> void:
	#Data.save()
	Data.load_save()
	$"../Light/WorldEnvironment".apply_settings()
	$"../Light/WorldEnvironment".sdfi_reset()
	is_active = false
	
	match Data.camera_smooth:
		true:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Camera/SmoothCamera.button_pressed = true
		false:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Camera/SmoothCamera.button_pressed = false
	
	if Data.ssr:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSR/SSR.button_pressed = true
	else:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSR/SSR.button_pressed = false
	
	if Data.ssao:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSAO/SSAO.button_pressed = true
	else:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSAO/SSAO.button_pressed = false
	
	if Data.ssil:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSIL/SSIL.button_pressed = true
	else:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SSIL/SSIL.button_pressed = false
	
	match Data.sdfgi:
		0:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SDFGI/SDFGI.selected = 0
		1:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SDFGI/SDFGI.selected = 1
		2:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/SDFGI/SDFGI.selected = 2
	
	if Data.glow:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Glow/Glow.button_pressed = true
	else:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Glow/Glow.button_pressed = false
	
	if Data.volumetric_fog:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/VolumetricFog/VolumetricFog.button_pressed = true
	else:
		$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/VolumetricFog/VolumetricFog.button_pressed = false
	
	$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Props/PropsButton.button_pressed = Data.props
	
	match Data.shadow:
		0:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Shadows/Shadows.selected = 0
		1:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Shadows/Shadows.selected = 1
		2:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Shadows/Shadows.selected = 2
	
	match Data.msaa:
		'disabled':
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/MSAA/MSAA.selected = 0
		'2x':
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/MSAA/MSAA.selected = 1
		'4x':
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/MSAA/MSAA.selected = 2
		'8x':
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/MSAA/MSAA.selected = 3
	
	match Data.scale3d_mode:
		0:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/ScaleMode/ScaleMode.selected = 0
		1:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/ScaleMode/ScaleMode.selected = 1
	
	match Data.scale3d:
		0:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/ScaleMode/ScaleMode.selected = 0
		1:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/ScaleMode/ScaleMode.selected = 1
		2:
			$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/ScaleMode/ScaleMode.selected = 2
	
	is_active = true


func _on_button_pressed() -> void:
	$Side/Button.hide()
	$Side/Quit.hide()
	$Side/Settings.hide()
	$GridContainer.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$Side/Button.show()
	$Side/Quit.show()
	$Side/Settings.show()
	$GridContainer.hide()


func _on_settings_pressed() -> void:
	$SettingsMenu.show()
	$Side/Button.hide()
	$Side/Settings.hide()
	$Side/Quit.hide()


func _on_back_2_pressed() -> void:
	$Side/Settings.show()
	$SettingsMenu.hide()
	$Side/Button.show()
	$Side/Settings.show()
	$Side/Quit.show()


func _on_option_button_item_selected(index: int) -> void:
	if not is_active:
		return
	match index:
		0:
			Data.health = 10
		1:
			Data.health = 5
		2:
			Data.health = 3
		3:
			Data.health = 0


func _on_smooth_camera_pressed() -> void:
	if not is_active:
		return
	Data.camera_smooth = not Data.camera_smooth
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_ssr_pressed() -> void:
	if not is_active:
		return
	Data.ssr = not Data.ssr
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_ssao_pressed() -> void:
	if not is_active:
		return
	Data.ssao = not Data.ssao
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_ssil_pressed() -> void:
	if not is_active:
		return
	Data.ssil = not Data.ssil
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_sdfgi_item_selected(index: int) -> void:
	if not is_active:
		return
	Data.sdfgi = index
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_volumetric_fog_pressed() -> void:
	if not is_active:
		return
	Data.volumetric_fog = not Data.volumetric_fog
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_scale_mode_item_selected(index: int) -> void:
	if not is_active:
		return
	match index:
		0:
			Data.scale3d_mode = 'linear'
		1:
			Data.scale3d_mode = 'FSR2'
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_scale_mode_2_item_selected(index: int) -> void:
	if not is_active:
		return
	match index:
		0:
			Data.scale3d = 1.0
		1:
			Data.scale3d = 0.7
		2:
			Data.scale3d = 0.5
	Data.save()
	$"../Light/WorldEnvironment".apply_settings()


func _on_glow_pressed() -> void:
	if not is_active:
		return
	Data.glow = not Data.glow
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_msaa_item_selected(index: int) -> void:
	if not is_active:
		return
	match index:
		0:
			Data.msaa = 'disabled'
		1:
			Data.msaa = '2x'
		2:
			Data.msaa = '4x'
		3:
			Data.msaa = '8x'
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_shadows_item_selected(index: int) -> void:
	if not is_active:
		return
	Data.shadow = index
	print(Data.shadow)
	$"../Light/WorldEnvironment".apply_settings()
	Data.save()


func _on_props_button_pressed() -> void:
	Data.props = not Data.props
	$SettingsMenu/Control/Panel/VScrollBar/VBoxContainer/Props/PropsButton.button_pressed = Data.props
	Data.save()
