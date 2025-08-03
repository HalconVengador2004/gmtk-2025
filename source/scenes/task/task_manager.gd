extends Node2D
class_name TaskManager

signal start_countdown()
signal stop_countdown()
signal score_updated(score: int)

@export var max_clock_stop_time: float = 60.0

var break_chance: float = 0.04
var max_break_chance: float = 0.20
var break_chance_increase_rate: float = 1.20
var hours_of_immunity: int = 3
var immunity_decrease_per_day: int = 1

var smart_objects: Array[Node] = []
var clock: Clock
var score: int = 0

func _ready():
	smart_objects = get_tree().get_nodes_in_group("smart_object")
	SignalBus.task_completed.connect(_on_task_completed)
	SignalBus.day_changed.connect(_on_day_changed)
	SignalBus.hour_changed.connect(_on_hour_changed)

	for so in smart_objects:
		if so is Clock:
			clock = so
			clock.create_task()
			break

func _physics_process(delta):
	for so in smart_objects:
		if so.has_task:
			if so.task.is_overdue() and not so.is_broken:
				so.is_broken = true

	clock.is_running = true
	for node in smart_objects:
		var so: SmartObject = node as SmartObject
		if so == null: continue
		if so.is_broken:
			clock.is_running = false
			break
	
	if clock.is_running:
		stop_countdown.emit()
	else:
		start_countdown.emit()
	

func _on_hour_changed(_hour: int):
	for node in smart_objects:
		var so: SmartObject = node as SmartObject
		if so == null: continue
		if not so.task or not so.task.resource: continue
		
		if so.hours_until_can_break > 0:
			so.hours_until_can_break -= 1
			continue

		if not so.has_task and not so.is_broken:
			if randf() < break_chance:
				so.create_task()
				print("creating task for %s" % so.name)

func _on_task_completed(task_data: Task):
	var time_taken: float = Time.get_ticks_msec() - task_data.start_time
	if time_taken <= 10000: # 10 seconds
		score += 20
	elif not task_data.is_overdue():
		score += 10
	else:
		score += 5
	score_updated.emit(score)

	for so in smart_objects:
		var smart_object = so as SmartObject
		if smart_object and smart_object.task == task_data:
			smart_object.hours_until_can_break = hours_of_immunity
			break

func _on_day_changed(_day: int):
	score += 100
	score_updated.emit(score)

	break_chance = min(break_chance * break_chance_increase_rate, max_break_chance)
	hours_of_immunity = max(hours_of_immunity - immunity_decrease_per_day, 0)
