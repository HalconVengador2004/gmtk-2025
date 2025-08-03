extends Node2D
class_name TaskManager

signal game_lost()
signal score_updated(score: int)

@export var create_task_chance: float = 0.5
@export var clock: Clock
@export var max_clock_stop_time: float = 60.0

var smart_objects: Array[Node] = []
var clock_stop_timer: float = 0.0
var score: int = 0

func _ready():
	smart_objects = get_tree().get_nodes_in_group("smart_object")
	SignalBus.task_completed.connect(_on_task_completed)
	SignalBus.day_changed.connect(_on_day_changed)

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
	
	if not clock.is_running:
		clock_stop_timer += delta
		if clock_stop_timer >= max_clock_stop_time:
			game_lost.emit()
	else:
		clock_stop_timer = 0

	for node in smart_objects:
		var so : SmartObject = node as SmartObject
		if so == null : continue
		if so.task_resource == null : continue
		if not so.has_task:
			if randf() < create_task_chance * delta:
				so.create_task()
				print("creating task")

func _on_task_completed(task_data: Task):
	var time_taken: float = Time.get_ticks_msec() - task_data.start_time
	if time_taken <= 10000: # 10 seconds
		score += 20
	elif not task_data.is_overdue():
		score += 10
	else:
		score += 5
	score_updated.emit(score)

func _on_day_changed(_day: int):
	score += 100
	score_updated.emit(score)
