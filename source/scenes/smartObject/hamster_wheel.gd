extends SmartObject

class_name HamsterWheel

@export var battery_capacity: float = 100.0
@export var battery_drain_rate: float = 1.0 

var battery_level: float = battery_capacity

func _physics_process(delta):
	battery_level -= battery_drain_rate * delta
	if battery_level <= 0:
		battery_level = 0

func charge(amount: float):
	battery_level += amount
	if battery_level > battery_capacity:
		battery_level = battery_capacity
