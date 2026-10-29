class_name Lazer extends Node3D

@export var all_active: bool
@export var timer: Timer
@export var is_wait: bool
@export var wait_time: float
@export var await_time: float = 1.0
@export var particles: GPUParticles3D
@export var anim: AnimationPlayer
var a = true
var is_active: bool = true


func _ready() -> void:
	if all_active:
		on()
		return
	timer.wait_time = wait_time
	if is_wait:
		await get_tree().create_timer(await_time).timeout
		timer.start(wait_time)
		return
	timer.start(wait_time)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('Player'):
		body.dead()
	if body is Box:
		body.position = body.start_pos


func timer_timeout() -> void:
	if not is_active: return
	if a:
		if particles:
			particles.emitting = false
		$Area3D.process_mode = Node.PROCESS_MODE_DISABLED
		$AudioStreamPlayer3D.volume_db = -50
		$Area3D.hide()
	else:
		if particles:
			particles.emitting = true
		$Area3D.process_mode = Node.PROCESS_MODE_INHERIT
		$AudioStreamPlayer3D.volume_db = 0
		$Area3D.show()
	a = not a


func off():
	is_active = false
	$GPUParticles3D.emitting = false
	$Area3D.process_mode = Node.PROCESS_MODE_DISABLED
	$AudioStreamPlayer3D.volume_db = -50
	$Area3D.hide()


func on():
	is_active = true
	$GPUParticles3D.emitting = true
	$Area3D.process_mode = Node.PROCESS_MODE_INHERIT
	$AudioStreamPlayer3D.volume_db = 0
	$Area3D.show()
