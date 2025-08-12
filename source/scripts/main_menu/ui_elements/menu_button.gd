extends Button

@export_group("Scales")
## Scale of the button when the button is hovered
@export var hover_scale: Vector2 = Vector2(1.2, 1.2)
## Scale of the button when the button is pressed
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export_group("Text Colors")
## Text color of the button when the button is untouched
@export var normal_text_color: Color = Color.DARK_GRAY
## Text color of the button when the button is hovered
@export var hover_text_color: Color = Color.WHITE
## Text color of the button when the button is pressed
@export var pressed_text_color: Color = Color.DIM_GRAY

@export_group("Center Point")
## The center point of the Button, used for animating. x and y values are limited between 0 and 1. With 0 is left/top and 1 is right/bottom. 
@export_range(0.0, 1.0, 0.05) var center_point_x: float = 0.5
## The center point of the Button, used for animating. x and y values are limited between 0 and 1. With 0 is left/top and 1 is right/bottom. 
@export_range(0.0, 1.0, 0.05) var center_point_y: float = 0.5

@export_group("Sounds")
## Sound played when pressed
@onready var press_sound: AudioStreamPlayer = $"Press Sound"
## Sound played when hover (specifically on hover exit)
@onready var hover_sound: AudioStreamPlayer = $"Hover Sound"

@export_group("Sound Components")
## If true, hover sound will not be played. Used to prevent hover sound plays when not needed.
var mute_next_hover_sound: bool = false

@export_group("Signal")
## Sound played when hover
@export var wait_pressed_time: float = 0.18
## Sound played when hover
signal pressed_after_wait_time_

func _ready() -> void:
	# Set center point of the button
	call_deferred("_init_pivot")
	
	# Connect entered signals
	mouse_entered.connect(_self_entered)
	focus_entered.connect(_self_entered)
	
	# Connect exited signals
	mouse_exited.connect(_self_exited)
	focus_exited.connect(_self_exited)
	focus_exited.connect(_self_exited_focus)
	
	# Connect pressed signals
	pressed.connect(_self_pressed)
	


# Set center point of the button
func _init_pivot():
	pivot_offset.x = size.x * center_point_x # Horizontal Center
	pivot_offset.y = size.y * center_point_y # Vertical Center

# When mouse entered
func _self_entered():
	call_deferred("_init_pivot")
	# Change focus and change to hover stage
	grab_focus()
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "theme_override_colors/font_color", hover_text_color, 0.1).set_trans(Tween.TRANS_SINE)
	
	# Allow the hover sound to play when exit
	mute_next_hover_sound = false

# When mouse exited (may or may not still focused)
func _self_exited():
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "theme_override_colors/font_color", normal_text_color, 0.1).set_trans(Tween.TRANS_SINE)

# When exit focus
func _self_exited_focus():
	# If hover sound is not muted
	if !mute_next_hover_sound:
		hover_sound.play()

# When pressed
func _self_pressed():
	# Change scale to pressed stage's scale
	var self_pressed_tween: Tween = create_tween()
	self_pressed_tween.tween_property(self, "scale", pressed_scale, 0.06).set_trans(Tween.TRANS_SINE)
	self_pressed_tween.tween_property(self, "scale", hover_scale, 0.12).set_trans(Tween.TRANS_SINE)
	
	# Change font color to pressed stage's font color
	var self_pressed_tween2: Tween = create_tween()
	self_pressed_tween2.tween_property(self, "theme_override_colors/font_color", hover_text_color, 0.06).set_trans(Tween.TRANS_SINE)
	self_pressed_tween2.tween_property(self, "theme_override_colors/font_color", pressed_text_color, 0.12).set_trans(Tween.TRANS_SINE)
	
	# Play press sound and disable hover sound when exit
	press_sound.play()
	mute_next_hover_sound = true
	
	# Wait until the button animation is finished then emit signal
	await get_tree().create_timer(wait_pressed_time).timeout
	emit_signal("pressed_after_wait_time_")
