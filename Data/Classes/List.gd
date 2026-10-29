class_name List extends Area3D

@export var text: String
@export var is_callable: bool
@export var await_time: int = 0
var is_area: bool = false
var is_used: bool = false

signal callable


func _ready() -> void:

	$UI.hide()
	$UI.label.text = text
	body_entered.connect(inp)
	body_exited.connect(out)


func _physics_process(_delta: float) -> void:
	if not is_area: return
	
	if Input.is_action_just_pressed('E'):
		if is_used:
			$UI.hide()
		else:
			$UI.show()
		is_used = not is_used


func inp(body: Node3D):
	if body.is_in_group('Player'):
		is_area = true


func out(body: Node3D):
	if body.is_in_group('Player'):
		is_area = false
		$UI.hide()


func _on_ui_hidden() -> void:
	if $Timer.is_stopped():
		await get_tree().create_timer(await_time).timeout
		callable.emit()
