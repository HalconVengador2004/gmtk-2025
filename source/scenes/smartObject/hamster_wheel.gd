extends SmartObject

class_name HamsterWheel

@onready var anim_sprite: AnimatedSprite2D = $HighlightableSprite

@export var battery_capacity: float = 100.0
@export var battery_drain_rate: float = 1.0
@export var charge_rate: float = 5.0
@export var battery_bar: ProgressBar
var battery_level: float = battery_capacity
var is_occupied_by: Worker = null

func _ready():
	super()
	SignalBus.connect("worker_charging", _on_worker_charging)
	SignalBus.connect("worker_stopped_charging", _on_worker_stopped_charging)
	anim_sprite.play('default')

func _physics_process(delta):
	battery_level -= battery_drain_rate * delta
	if battery_level <= 0:
		battery_level = 0

	update_battery_bar()

func charge(delta: float):
	battery_level += charge_rate * delta
	if battery_level > battery_capacity:
		battery_level = battery_capacity

func occupy(worker: Worker) -> void:
	is_occupied_by = worker

func release() -> void:
	is_occupied_by = null
	visible = true
	anim_sprite.play('default')

func update_battery_bar():
	battery_bar.value = battery_level
	var battery_percentage = battery_level / battery_capacity
	battery_bar.material.set_shader_parameter("progress", battery_percentage)

func _on_worker_charging():
	if is_occupied_by:
		anim_sprite.play('run')

func _on_worker_stopped_charging():
	if is_occupied_by:
		anim_sprite.play('default')
