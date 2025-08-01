extends MarginContainer

@export var element_to_focused: Node

func _on_menu_appeared() -> void:
	if element_to_focused != null:
		element_to_focused.grab_focus()

func _ready() -> void:
	call_deferred("_init_pivot")

func _init_pivot():
	pivot_offset = size/2.0

@onready var main_menu: Control = $".."
func back_to_main_menu() -> void:
	main_menu.menu_to_main(self)
