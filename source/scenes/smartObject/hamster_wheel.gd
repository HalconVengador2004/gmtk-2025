extends SmartObject

class_name HamsterWheel

@export var battery_capacity: float = 100.0
@export var battery_drain_rate: float = 1.0
@export var charge_rate: float = 5.0

@onready var battery_bar: ProgressBar = $ProgressBar
var battery_level: float = battery_capacity

func _ready():
	super()

func _physics_process(delta):
	battery_level -= battery_drain_rate * delta
	if battery_level <= 0:
		battery_level = 0

	update_battery_bar()

func charge(delta: float):
	battery_level += charge_rate * delta
	if battery_level > battery_capacity:
		battery_level = battery_capacity


func update_battery_bar():
	battery_bar.value = battery_level
	var battery_percentage = battery_level / battery_capacity
	battery_bar.material.set_shader_parameter("progress", battery_percentage)
