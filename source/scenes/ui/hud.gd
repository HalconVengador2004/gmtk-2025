extends CanvasLayer

## HUD
@onready var score_label: Label = $HUD/ScoreLabel
@onready var countdown_label: Label = $HUD/CountdownLabel

## Menus
@onready var game_over_menu: MarginContainer = $GameOverMenu
@onready var pause_menu: MarginContainer = $PauseMenu
@onready var dark_bg: ColorRect = $DarkBG

## Game Over
@onready var game_over_score_label: Label = $GameOverMenu/Panel/MarginContainer/ContentContainer/ScoreContainer/GameOverScoreLabel
@onready var game_iver_high_score_label: Label = $GameOverMenu/Panel/MarginContainer/ContentContainer/HighScoreContainer/GameIverHighScoreLabel
var local_score: int = 0
var is_counting_down: bool = false:
	set(value):
		is_counting_down = value
		if is_counting_down:
			countdown_label.show()
		else:
			countdown_label.hide()
@onready var countdown_timer: Timer = $CountdownTimer
var is_game_over: bool = false

## Pause
var is_pausing: bool = false
var can_pause_again: bool = true

@export_group("Buttons")
@export var game_over_menu_button_to_focus: Button
@export var pause_menu_button_to_focus: Button

@export_group("Normal Countdown Text")
@export var normal_font_color: Color = Color.WHITE
@export var normal_font_size: int = 42
@export var normal_outline_size: int = 4

@export_group("Urgent Countdown Text")
@export var urgent_font_color: Color = Color.ORANGE_RED
@export var urgent_font_size: int = 84
@export var urgent_outline_size: int = 16

func _ready():
	countdown_label.hide()
	game_over_menu.hide()
	pause_menu.hide()
	call_deferred("_init_pivot")
	
	start_countdown()

func _process(delta: float) -> void:
	if is_counting_down:
		if int(countdown_timer.time_left) > 4:
			countdown_label.add_theme_color_override("font_color", normal_font_color)
			countdown_label.add_theme_font_size_override("font_size", normal_font_size)
			countdown_label.add_theme_constant_override("outline_size", normal_outline_size)
		else:
			countdown_label.add_theme_color_override("font_color", urgent_font_color)
			countdown_label.add_theme_font_size_override("font_size", urgent_font_size)
			countdown_label.add_theme_constant_override("outline_size", urgent_outline_size)
		
		countdown_label.text = str(int(countdown_timer.time_left)) #str("%.0f" % countdown_timer.time_left)
	
	
	if Input.is_action_just_pressed("Pause") and !is_game_over and can_pause_again:
		show_pause()
		can_pause_again = false
		await get_tree().create_timer(0.5).timeout
		can_pause_again = true

# For Animation
func _init_pivot():
	game_over_menu.pivot_offset = game_over_menu.size/2.0
	pause_menu.pivot_offset = pause_menu.size/2.0

func show_game_over(score: int):
	await get_tree().create_timer(1).timeout
	menu_appear_animation(game_over_menu)
	
	game_over_score_label.text = str(score)
	game_over_menu_button_to_focus.grab_focus()
	score_label.hide()
	countdown_label.hide()
func show_pause():
	if !is_pausing:
		menu_appear_animation(pause_menu)
		is_pausing = true
		pause_menu_button_to_focus.grab_focus()
		get_tree().paused = true
	else:
		var current_focus_node = get_viewport().gui_get_focus_owner()
		if current_focus_node and ("mute_next_hover_sound" in current_focus_node):
			current_focus_node.mute_next_hover_sound = true
		menu_disappear_animation(pause_menu)
		is_pausing = false
		get_tree().paused = false

func menu_appear_animation(menu: Node):
	# Dark BG appears
	dark_bg.visible = true
	dark_bg.color = Color(0,0,0,0)
	create_tween().tween_property(dark_bg, "color", Color(0,0,0,0.7), 0.25).set_trans(Tween.TRANS_SINE)

	# Menu Setup and Animation
	menu.show()
	menu.modulate = Color(0,0,0,0)
	menu.scale = Vector2(0.5,0.5)
	create_tween().tween_property(menu, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(menu, "modulate", Color(1,1,1,1), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Run after Animation
	await get_tree().create_timer(0.25).timeout
func menu_disappear_animation(menu: Node):
	var tween := create_tween().tween_property(dark_bg, "color", Color(0,0,0,0), 0.25).set_trans(Tween.TRANS_SINE)
	await tween.finished
	dark_bg.visible = false
	
	# Settings Menu Setup and Animation
	menu.scale = Vector2.ONE
	create_tween().tween_property(menu, "scale", Vector2(0.5,0.5), 0.1).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(menu, "modulate", Color(0, 0, 0, 0), 0.1).set_trans(Tween.TRANS_SINE)
	
	# Titlescreen Animation after Settings Animation
	await get_tree().create_timer(0.1).timeout
	menu.visible = false


func _on_countdown_timer_timeout() -> void:
	show_game_over(local_score)
	is_game_over = true
	get_tree().paused = true


## Buttons
func _on_play_again_button_pressed_after_wait_time_() -> void:
	is_pausing = false
	get_tree().paused = false
	SceneManager.reload_scene()
func _on_back_button_pressed_after_wait_time_() -> void:
	is_pausing = false
	get_tree().paused = false
	SceneManager.change_scene("res://source/scenes/ui/main_menu.tscn")
func _on_resume_button_pressed_after_wait_time_() -> void:
	menu_disappear_animation(pause_menu)
	is_pausing = false
## Functions
#Update the score
func update_score(score: int):
	score_label.text = "Score: " + str(score)
	local_score = score

# Start Countdown when the clock is not working
func start_countdown():
	if countdown_timer.time_left > 0:
		return
	countdown_timer.start()
	is_counting_down = true

# Stop Countdown when the clock works again
func stop_countdown():
	countdown_timer.stop()
	is_counting_down = false
