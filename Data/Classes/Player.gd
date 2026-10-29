class_name Player extends RigidBody3D


@export_group("Camera")
@export var camera: Camera3D
@export var camera_smooth: bool = true


@export_group("Movement")
@export var speed: float = 10.0 # Максимальная скорость по X
@export var acceleration: float = 2.5 # Ускорение (чем выше, тем меньше "скольжения")
@export var friction: float = 5.0 # Трение (чем выше, тем быстрее остановка)
@export var speed_rotation: float = 500.0 # Скорость вращения
@export var jump_force: float = 12.0 # Сила прыжка
@export var colision: CollisionShape3D

var joystick_input: Vector2


@export_group("Animation")
@export var anim_swith_speed: float = 0.1
@export var anim_gravity_swith_speed: float = 10.0
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree


@export_group("RayCasts")
@export var ground_cast: RayCast3D # Проверка пола
@export var ground_cast2: RayCast3D # Проверка пола
@export var roof_cast: RayCast3D # Проверка потолка при инвертированной гравитации
@export var roof_cast2: RayCast3D # Проверка потолка при инвертированной гравитации
@export var anim_cast: RayCast3D # Проверка удара об объект сверху


@export_group("Sound")
@export var sound_walk: AudioStreamPlayer3D
@export var dead_sound: AudioStreamPlayer3D


@export_group("Visual")
@export var logo: ColorRect
@export var mesh: MeshInstance3D

@export var menu: Control
@export var menu_button: Control


var save_point: Vector3 = Vector3.ZERO
var is_fly: bool = false
var anim: float = 0.0

# Сохраняем ввод отдельно от физики.
var input_dir: float = 0.0

# переменные без обозначения
var state_machine
var one_shot

var value = 0.0 #x
var value2 = 0.0 #y

var direction: Vector3 = Vector3.ZERO
var previous_position: Vector3

var compressing: bool = true

# Состояние игрока относительно земли.
var was_on_ground: bool = false

var gravity_reversed: bool = false


func _ready():
	
	save_point = position
	
	camera_smooth = Data.camera_smooth
	
	save_point = position
	
	state_machine = animation_tree["parameters/StateMachine/playback"]
	one_shot = animation_tree["parameters/OneShotAnimations/playback"]
	#state_machine.travel("Moving")
	
	# Начальное состояние.
	was_on_ground = is_on_ground()
	
	# Блокируем вращение физического тела,
	# чтобы игрок не падал как кегля.
	lock_rotation = true
	
	# Игра является 2.5D:
	# движение по Z запрещено.
	axis_lock_linear_z = true


func _physics_process(delta):
	
	# ----------------------------------------
	# СМЕРТЬ
	# ----------------------------------------
	
	if position.y < -20:
		dead()
	
	
	# ----------------------------------------
	# ПОЛУЧЕНИЕ ВВОДА
	# ----------------------------------------
	
	input_dir = Input.get_axis("ui_left", "ui_right")# + joystick_input.x
	
	
	# ----------------------------------------
	# ВРАЩЕНИЕ
	# ----------------------------------------
	
	var local_y := rad_to_deg(mesh.rotation.y)
	
	if input_dir < 0:
		anim = clamp(anim + anim_swith_speed, 0.0, 1.0)
		local_y -= speed_rotation * delta
	elif input_dir > 0:
		anim = clamp(anim + anim_swith_speed, 0.0, 1.0)
		local_y += speed_rotation * delta
	else:
		anim = clamp(anim - anim_swith_speed, 0.0, 1.0)
	
	local_y = clamp(local_y, -270.0, -90.0)
	
	mesh.rotation.y = deg_to_rad(local_y)
	
	# ----------------------------------------
	# ЗВУК ХОДЬБЫ
	# ----------------------------------------
	
	if input_dir != 0:
		sound_walk.volume_db = clamp(
			sound_walk.volume_db + 0.5,
			-50.0,
			-5.0
		)
	else:
		sound_walk.volume_db = clamp(
			sound_walk.volume_db - 0.5,
			-50.0,
			-5.0
		)
	
	
	# ----------------------------------------
	# ПРЫЖОК
	# ----------------------------------------
	
	if Input.is_action_just_pressed("ui_up"):
		animation_tree.set(
			"parameters/OneShot/request",
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
		)
		jump()
	
	
	# ----------------------------------------
	# АНИМАЦИЯ
	# ----------------------------------------
	
	var current_position := global_position
	
	# Движение игрока с прошлого кадра
	direction = current_position - previous_position
	
	previous_position = current_position
	
	update_direction(delta)
	play_compression()
	
	# Проверяем полёт и приземление.
	update_flight_state()
	
	if not is_on_ground():
		animation_tree.set(
			"parameters/OneShot/request",
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
		)
	if gravity_scale < 0:
		mesh.scale.y = move_toward(mesh.scale.y, -0.76, delta * anim_gravity_swith_speed)
		colision.position = GodoTools.move_toward_3d(colision.position, Vector3(0, -0.5, 0), delta * anim_gravity_swith_speed)
		#camera.position = GodoTools.move_toward_3d(camera.position, Vector3(0, -1.4, 7), delta * anim_gravity_swith_speed)
	else:
		mesh.scale.y = move_toward(mesh.scale.y, 0.76, delta * anim_gravity_swith_speed)
		colision.position = GodoTools.move_toward_3d(colision.position, Vector3(0, 0.5, 0), delta * anim_gravity_swith_speed)
		#camera.position = GodoTools.move_toward_3d(camera.position, Vector3(0, 1.4, 7), delta * anim_gravity_swith_speed)
	
	$UI/Label.text = str(direction)


## Проверяет состояние игрока: земля / воздух.
func update_flight_state() -> void:
	var on_ground := is_on_ground()
	
	# Игрок был в воздухе и теперь коснулся земли.
	if not was_on_ground and on_ground:
		compressing = true
	
	# Обновляем состояние для следующего кадра.
	was_on_ground = on_ground


## Запускает OneShot-анимацию Compression.
func play_compression() -> void:
	if mesh.get_blend_shape_value(15) == 0 and mesh.get_blend_shape_value(16) == 0 and compressing:
		compressing = false
		animation_tree.set(
			"parameters/OneShot/request",
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		)


## анимация
func update_direction(delta: float) -> void:
	var acceleration_speed := 5.0
	
	# y
	if gravity_scale > 0:
		if direction.normalized().y > 0:
			value2 = move_toward(value2, 1.0, acceleration_speed * delta)
		elif direction.normalized().y < 0:
			value2 = move_toward(value2, -1.0, acceleration_speed * delta)
		else:
			value2 = move_toward(value2, 0.0, acceleration_speed * delta)
	else:
		if direction.normalized().y < 0:
			value2 = move_toward(value2, 1.0, acceleration_speed * delta)
		elif direction.normalized().y > 0:
			value2 = move_toward(value2, -1.0, acceleration_speed * delta)
		else:
			value2 = move_toward(value2, 0.0, acceleration_speed * delta)
	
	if is_on_ground():
		value2 = move_toward(value2, 0.0, acceleration_speed * delta)
	
	# x
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		value = move_toward(value, 1.0, acceleration_speed * delta)
	else:
		value = move_toward(value, 0.0, acceleration_speed * delta)
	
	animation_tree.set(
		"parameters/StateMachine/Moving/blend_position",
		Vector2(value2, value)
	)
	animation_tree.set(
		"parameters/OneShotAnimations/Compression/blend_position",
		Vector2(value2, value)
	)


func _integrate_forces(state: PhysicsDirectBodyState3D):
	# Здесь происходит непосредственно физическое
	# управление RigidBody3D.
	
	var current_velocity := state.linear_velocity
	
	# ----------------------------------------
	# ДВИЖЕНИЕ ПО X
	# ----------------------------------------
	
	var target_velocity_x := input_dir * speed
	
	if input_dir != 0:
		var velocity_difference := target_velocity_x - current_velocity.x
		
		var force := velocity_difference * acceleration * mass
		
		state.apply_central_force(Vector3(force, 0.0, 0.0))
	else:
		var force := -current_velocity.x * friction * mass
		
		state.apply_central_force(Vector3(force, 0.0, 0.0))
	
	
	# ----------------------------------------
	# ФИКСАЦИЯ Z
	# ----------------------------------------
	
	state.linear_velocity.z = 0.0


func jump():
	var current_velocity := linear_velocity
	
	# ----------------------------------------
	# ОБЫЧНАЯ ГРАВИТАЦИЯ
	# ----------------------------------------
	
	if gravity_scale >= 0:
		if is_on_ground():
			current_velocity.y = 0.0
			linear_velocity = current_velocity
			
			apply_central_impulse(Vector3.UP * jump_force)
	
	else:
		if is_on_ground():
			current_velocity.y = 0.0
			linear_velocity = current_velocity
			
			apply_central_impulse(Vector3.DOWN * jump_force)


func is_on_ground() -> bool:
	# Проверка пола через RayCast3D.
	return (ground_cast.is_colliding() or ground_cast2.is_colliding()) if gravity_scale > 0 else \
	(roof_cast.is_colliding() or roof_cast2.is_colliding())


func dead():
	dead_sound.play()
	
	if save_point:
		position = save_point
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO


func gravity_reverse():
	gravity_scale *= -1
	gravity_reversed = not gravity_reversed


func get_camera() -> Camera3D:
	return camera


func camera_offset(offset: Vector3):
	camera.target_offset = offset


func _on_virtual_joystick_flicked(input_vector: Vector2) -> void:
	joystick_input = input_vector
