@tool
extends Area2D
class_name InteractableComponent

var is_pressed: bool = false

func _ready():
	input_pickable = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_pressed = event.is_pressed()
		if is_pressed:
			get_viewport().set_input_as_handled()

func _process(_delta):
	if not is_pressed:
		return
	
	is_pressed = false
