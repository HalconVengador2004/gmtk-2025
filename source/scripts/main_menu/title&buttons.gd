extends MarginContainer

# Last button focus before changing menu
var last_focused_button: Button

func _ready() -> void:
	for button in $"Title&Buttons/ButtonMarginContainer/ButtonContainer".get_children():
		button.pressed.connect(_on_pressed.bind(button))

func _on_pressed(button):
	last_focused_button = button

func _on_menu_appeared() -> void:
	if last_focused_button:
		last_focused_button.grab_focus()


@onready var main_menu: Control = $".."
func options_menu() -> void:
	main_menu.main_to_menu(main_menu.menus[1])


func _on_how_to_play_button_pressed_after_wait_time_() -> void:
	main_menu.main_to_menu(main_menu.menus[2])
