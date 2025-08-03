extends Node

const hour_number : float = 12.0
const minutes_per_hour : float = 60

var time : float = 0.0
var paused : bool = false
var speed : float = 1.0
var game_hour_real_duration_seconds : float = 7.5
var current_day : int = 0

func _physics_process(delta: float) -> void:
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
	return fractional_hour * minutes_per_hour

func _check_day():
	if get_day() > current_day:
		current_day = get_day()
		SignalBus.day_changed.emit(current_day) 
