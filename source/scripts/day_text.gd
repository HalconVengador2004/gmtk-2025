extends Label


func _ready():
	SignalBus.connect("day_changed", _update_day)
	_update_day(0)
	
func _update_day(_new_day):
	text = "Day " + str(_new_day + 1)
