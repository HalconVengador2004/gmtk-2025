extends SmartObject
class_name Clock

@onready var minute_hand = $MinuteHand
@onready var hour_hand = $HourHand

var stopped: bool = false
var time: float = 0.0
var current_day: int = 0

func _ready():
	super()
	task = null

func _process(delta):
	if not stopped:
		time += delta
		var minutes = (time / 60)
		var hours = (time / 3600)
		minute_hand.rotation = deg_to_rad(minute_to_deg(minutes))
		hour_hand.rotation = deg_to_rad(hour_to_deg(hours))
		_check_day()

func _check_day():
	var day = floor(time / 86400) # 86400 seconds in a day
	if day > current_day:
		current_day = day
		SignalBus.day_changed.emit(current_day)
	
func hour_to_deg(game_hour: float) -> float:
	return fmod(game_hour, 12.0) * (360.0 / 12.0)

func minute_to_deg(game_minute: float) -> float:
	return fmod(game_minute, 60.0) * (360.0 / 60.0)
