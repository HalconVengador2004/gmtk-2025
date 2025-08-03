extends Control

## Button to focus when first enter scene
@export var start_focused_button: Button

## Menus
@export var menus: Array[Control]

func _ready() -> void:
	## Set mouse to be visible and grab focus to the assigned button
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_focused_button.grab_focus()

func main_to_menu(menu: Control):
	# Title and Button Disappear Animation
	create_tween().tween_property(menus[0], "position", Vector2(-size.x, 0), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Dark BG appears
	background_appear_animation()
	
	# Menu Setup and Animation
	menu.visible = true
	menu.modulate = Color(0,0,0,0)
	menu.scale = Vector2(0.5,0.5)
	create_tween().tween_property(menu, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(menu, "modulate", Color(1,1,1,1), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Run after Animation
	await get_tree().create_timer(0.25).timeout
	menus[0].visible = false
	menu._on_menu_appeared()

func menu_to_main(menu: Control):
	# Titlescreen Setup
	menus[0].visible = true
	background_disappear_animation()
	
	# Settings Menu Setup and Animation
	menu.scale = Vector2.ONE
	create_tween().tween_property(menu, "scale", Vector2(0.5,0.5), 0.25).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(menu, "modulate", Color(0, 0, 0, 0), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Titlescreen Animation after Settings Animation
	await get_tree().create_timer(0.1).timeout
	create_tween().tween_property(menus[0], "position", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_SINE)
	
	# Run after Animation
	await get_tree().create_timer(0.15).timeout
	menu.visible = false
	menus[0]._on_menu_appeared()


@onready var dark_bg: ColorRect = $DarkBG
func background_appear_animation():
	dark_bg.visible = true
	dark_bg.color = Color(0,0,0,0)
	create_tween().tween_property(dark_bg, "color", Color(0,0,0,0.7), 0.25).set_trans(Tween.TRANS_SINE)

func background_disappear_animation():
	var tween := create_tween().tween_property(dark_bg, "color", Color(0,0,0,0), 0.25).set_trans(Tween.TRANS_SINE)
	await tween.finished
	dark_bg.visible = false

func change_scene_to_game():
	SceneManager.change_scene("res://source/scenes/game/game.tscn")

func quit_game() -> void:
	await SceneManager.fade_out()
	get_tree().quit()
