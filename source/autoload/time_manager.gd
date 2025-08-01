extends Node

var time : float = 0.0
var paused : bool = false
var speed : float = 1.0
var hour_number : float = 12.0
var game_hour_real_duration_seconds : float = 30.0
var game_hour_game_minutes_duration : float = 60.0

var current_day : int = 0


func _process(delta: float):
	if paused:
		return
	time += delta * speed
	_check_day()

func get_time() -> float:
	return time

func reset_time():
	time = 0.0

func pause():
	paused = true

func resume():
	paused = false

func set_speed(new_speed: float):
	speed = new_speed

func get_day() -> int:
	return floor(time / (game_hour_real_duration_seconds * hour_number))
	
# [0,1]
func get_day_progress() -> float:
	return time / (game_hour_real_duration_seconds * hour_number) - get_day()
	
func get_hour() -> float:
	return time / game_hour_real_duration_seconds - current_day * hour_number

func get_minute() -> float:
	var fractional_hour = get_hour() - floor(get_hour())
	return fractional_hour * game_hour_game_minutes_duration

func _check_day():
	if get_day() > current_day:
		current_day = get_day()
		SignalBus.day_changed.emit(current_day) 
