class_name Gun extends Node3D

@export var domain_bullet_scene: PackedScene = preload("res://Assets/Objects/Gun/domain_bullet.tscn")
@export var bullet: PackedScene
@export var dir: Vector3
@export var timer: Timer
@export var time_wait: float = 5.0
@export var time_wait_ready: float = 0.0
var is_active: bool = true


func _ready() -> void:
	if time_wait_ready:
		is_active = false
		await get_tree().create_timer(time_wait_ready).timeout
		is_active = true
	timer.timeout.connect(timer_timeout)
	timer.start(time_wait)


func timer_timeout() -> void:
	if not is_active: return
	var domain: Node3D = domain_bullet_scene.instantiate()
	domain.position = position
	domain.rotation = rotation
	domain.scale = scale
	get_parent().add_child(domain)
	var scene = bullet.instantiate()
	scene.dir = dir
	domain.add_child(scene)


func on():
	is_active = true


func off():
	is_active = false
