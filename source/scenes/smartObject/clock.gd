extends SmartObject
class_name Clock

@onready var minute_hand = $MinuteHand
@onready var hour_hand = $HourHand
var is_running: bool = true

func _ready():
	super()
	task = null

func _physics_process(_delta):
	if is_running:
		var minutes = TimeManager.get_minute()
		var hours = TimeManager.get_hour()
		minute_hand.rotation = deg_to_rad(minute_to_deg(minutes))
		hour_hand.rotation = deg_to_rad(hour_to_deg(hours))
	
func hour_to_deg(game_hour: float) -> float:
	return fmod(game_hour, 12.0) * (360.0 / 12.0)

func minute_to_deg(game_minute: float) -> float:
	return fmod(game_minute, 60.0) * (360.0 / 60.0)
