@tool
extends Area2D
class_name InteractableComponent

signal hovered
signal unhovered
signal selected

func _ready():
	mouse_entered.connect(func(): emit_signal("hovered", get_parent()))
	mouse_exited.connect(func(): emit_signal("unhovered", get_parent()))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("selected", get_parent())
		get_viewport().set_input_as_handled()
