extends  SmartObject
class_name Clock

@onready var minute_hand = $MinuteHand
@onready var hour_hand = $HourHand

func _ready():
	super()
	task = null

func _process(_delta):
	minute_hand.rotation = deg_to_rad(minute_to_deg(TimeManager.get_minute()))
	hour_hand.rotation = deg_to_rad(hour_to_deg(TimeManager.get_hour()))
	
func hour_to_deg(game_hour: float) -> float:
	return game_hour * (360.0 / TimeManager.hour_number)

func minute_to_deg(game_minute: float) -> float:
	return game_minute * (360.0 / TimeManager.game_hour_game_minutes_duration)
