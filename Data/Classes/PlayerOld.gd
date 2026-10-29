class_name PlayerOld extends RigidBody3D

@export var camera: Camera3D

@export var camera_smooth: bool = true
@export var speed = 10.0 # Максимальная скорость по X
@export var speed_rotation = 500.0 # скорость вращения
@export var acceleration = 2.5 # Ускорение (чем выше, тем меньше "скольжения")
@export var friction = 5.0 # Трение (как быстро игрок останавливается)
@export var jump_force = 12.0 # Сила прыжка
@export var anim_swith_speed = 0.1

@export var ground_cast: RayCast3D # Узел для проверки пола
@export var roof_cast: RayCast3D # Узел для проверки пола, при инвертированной гравитации
@export var anim_cast: RayCast3D # Узел для активации анимации удара об что-то сверху

@export var sound_walk: AudioStreamPlayer3D
@export var dead_sound: AudioStreamPlayer3D

@export var logo: ColorRect

@export var mesh: MeshInstance3D
@export var animation_player: AnimationPlayer

var save_point: Vector3 = Vector3.ZERO
var is_fly: bool = false
var anim: float = 0.0


func _ready():
	camera_smooth = Data.camera_smooth
	
	save_point = position
	# Блокируем вращение, чтобы игрок не падал как кегля
	lock_rotation = true
	# Отключаем влияние гравитации на ось Z через настройки осей (опционально)
	axis_lock_linear_z = true


func _physics_process(delta):
	if position.y < -20:
		dead()
	
	# 1. Получаем ввод (влево/вправо)
	var input_dir = Input.get_axis("ui_left", "ui_right")
	
	# вращение по оси y
	var local_y = rad_to_deg(mesh.rotation.y)
	if input_dir < 0:
		anim = clamp(anim + anim_swith_speed, 0, 1)
		local_y -= speed_rotation * delta
	elif input_dir > 0:
		anim = clamp(anim + anim_swith_speed, 0, 1)
		local_y += speed_rotation * delta
	else:
		anim = clamp(anim - anim_swith_speed, 0, 1)
	local_y = clamp(local_y, -270, -90)
	mesh.rotation.y = deg_to_rad(local_y)
	
	# анимация движения
	if animation_player.current_animation == 'default_007':
		mesh.set_blend_shape_value(0, 0)
		anim = 0
	else:
		mesh.set_blend_shape_value(0, anim)
	
	# 2. Обработка движения по оси X
	var current_vel = linear_velocity
	var target_vel_x = input_dir * speed
	
	if input_dir != 0:
		# Плавный разгон
		sound_walk.volume_db = clamp(sound_walk.volume_db + 0.5, -50, -5)
		current_vel.x = lerp(current_vel.x, target_vel_x, acceleration * delta)
	else:
		# Плавное торможение (скольжение до остановки)
		sound_walk.volume_db = clamp(sound_walk.volume_db - 0.5, -50, -5)
		current_vel.x = lerp(current_vel.x, 0.0, friction * delta)
	
	# 3. Прыжок по оси Y
	if Input.is_action_just_pressed("ui_up"):
		if is_on_ground():
			current_vel.y = jump_force
		if gravity_scale < 0 and (roof_cast.is_colliding() or is_fly):
			current_vel.y = -jump_force
	
	# Анимация удара об что-то сверху
	if anim_cast.is_colliding() and gravity_scale > 0:
		animation_player.play('default_007')
	
	# 4. Строгая фиксация оси Z (на всякий случай)
	current_vel.z = 0
	
	# Применяем измененную скорость
	linear_velocity = current_vel


func is_on_ground():
	# Простая проверка через RayCast3D, направленный вниз
	return ground_cast.is_colliding()


func dead():
	dead_sound.play()
	if save_point:
		position = save_point


func camera_offset(offset: Vector3):
	camera.target_offset = offset


func push(direction: Vector3, force: float):
	linear_velocity = direction.normalized() * force
