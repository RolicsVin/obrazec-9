@tool
extends EditorPlugin


var button: Button
var selection: EditorSelection


func _enter_tree() -> void:
	selection = get_editor_interface().get_selection()

	button = Button.new()
	button.text = "Align"
	button.tooltip_text = "Move the first selected Node3D to the second selected Node3D"
	button.pressed.connect(_align_nodes)

	add_control_to_container(
		CONTAINER_SPATIAL_EDITOR_MENU,
		button
	)


func _exit_tree() -> void:
	if button:
		button.queue_free()


func _align_nodes() -> void:
	var nodes := selection.get_selected_nodes()
	
	if nodes.size() != 2:
		push_warning("Align Nodes: select exactly 2 Node3D nodes.")
		return
	
	if not nodes[0] is Node3D or not nodes[1] is Node3D:
		push_warning("Align Nodes: both selected nodes must be Node3D.")
		return
	
	var source: Node3D = nodes[0]
	var target: Node3D = nodes[1]
	
	# Перемещаем первый объект к второму
	source.global_position = target.global_position
