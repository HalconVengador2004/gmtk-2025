@tool
extends Area2D
class_name InteractableComponent

var is_pressed: bool = false
signal clicked(node)

func _ready():
	input_pickable = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_pressed = event.is_pressed()
		if is_pressed:
			get_viewport().set_input_as_handled()
			emit_signal("clicked", get_parent())


func _process(_delta):
	if not is_pressed:
		return
	
	is_pressed = false
