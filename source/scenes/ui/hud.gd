extends CanvasLayer

@onready var score_label: Label = $HUD/ScoreLabel
@onready var countdown_label: Label = $HUD/CountdownLabel

@onready var game_over_menu: MarginContainer = $GameOverMenu
@onready var dark_bg: ColorRect = $DarkBG

@onready var countdown_timer: Timer = $CountdownTimer
@export var button_to_focus: Button

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
func _ready():
	countdown_label.hide()
	game_over_menu.hide()
	call_deferred("_init_pivot")

func _process(delta: float) -> void:
	if is_counting_down:
		countdown_label.text = str("%.0f" % countdown_timer.time_left)

# For Animation
func _init_pivot():
	game_over_menu.pivot_offset = game_over_menu.size/2.0
func show_game_over(score: int):
	await get_tree().create_timer(2).timeout
	menu_appear_animation()
	
	game_over_score_label.text = str(score)
	button_to_focus.grab_focus()
	score_label.hide()
	countdown_label.hide()
func menu_appear_animation():
	# Dark BG appears
	dark_bg.visible = true
	dark_bg.color = Color(0,0,0,0)
	create_tween().tween_property(dark_bg, "color", Color(0,0,0,0.7), 0.25).set_trans(Tween.TRANS_SINE)

	# Menu Setup and Animation
	game_over_menu.show()
	game_over_menu.modulate = Color(0,0,0,0)
	game_over_menu.scale = Vector2(0.5,0.5)
	create_tween().tween_property(game_over_menu, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(game_over_menu, "modulate", Color(1,1,1,1), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Run after Animation
	await get_tree().create_timer(0.25).timeout

func _on_countdown_timer_timeout() -> void:
	show_game_over(local_score)


# Buttons
func _on_play_again_button_pressed_after_wait_time_() -> void:
	SceneManager.reload_scene()
func _on_back_button_pressed_after_wait_time_() -> void:
	SceneManager.change_scene("res://source/scenes/ui/main_menu.tscn")

# Functions
func update_score(score: int):
	score_label.text = "Score: " + str(score)
	local_score = score



# Start Countdown when the clock is not working
func start_countdown():
	countdown_timer.start()
	is_counting_down = true

# Stop Countdown when the clock works again
func stop_countdown():
	countdown_timer.stop()
	is_counting_down = false
