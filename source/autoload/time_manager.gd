extends Node

var time : float = 0.0
var paused : bool = false
var speed : float = 1.0

var hour_number : int = 12
var game_hour_real_duration_seconds : float = 30.0

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

func _check_day():
	if get_day() > current_day:
		current_day = get_day()
		SignalBus.day_changed.emit(current_day) 
