extends WorldEnvironment

func _ready() -> void:
	apply_settings()
	sdfi_reset()


func apply_settings() -> void:
	
	if environment == null:
		push_error("У WorldEnvironment отсутствует ресурс Environment.")
		return

	# Screen Space Reflections
	environment.ssr_enabled = Data.ssr

	# Ambient Occlusion
	environment.ssao_enabled = Data.ssao

	# Screen Space Indirect Lighting
	environment.ssil_enabled = Data.ssil
	
	# glow
	environment.glow_enabled = Data.glow

	# Volumetric Fog
	environment.volumetric_fog_enabled = Data.volumetric_fog

	# SDFGI
	match Data.sdfgi:
		0:
			environment.sdfgi_enabled = false
		1:
			environment.sdfgi_enabled = true
			environment.sdfgi_min_cell_size = 110
		2:
			environment.sdfgi_enabled = true
			environment.sdfgi_max_distance = 220

	# MSAA
	match Data.msaa:
		"disabled":
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		"2x":
			get_viewport().msaa_3d = Viewport.MSAA_2X
		"4x":
			get_viewport().msaa_3d = Viewport.MSAA_4X
		"8x":
			get_viewport().msaa_3d = Viewport.MSAA_8X

	# Масштабирование 3D
	get_viewport().scaling_3d_scale = Data.scale3d

	match Data.scale3d_mode:
		"linear":
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		"FSR2":
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2

	# Качество фильтра теней
	match Data.shadow:
		0:
			RenderingServer.directional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_HARD
			)
			RenderingServer.positional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_HARD
			)
		1:
			RenderingServer.directional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_SOFT_LOW
			)
			RenderingServer.positional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_SOFT_LOW
			)
		2:
			RenderingServer.directional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_SOFT_ULTRA
			)
			RenderingServer.positional_soft_shadow_filter_set_quality(
				RenderingServer.SHADOW_QUALITY_SOFT_ULTRA
			)


func sdfi_reset():
	environment.sdfgi_enabled = false
	await get_tree().create_timer(1.0).timeout
	environment.sdfgi_enabled = true
	print('SDFGI сброшен.')
