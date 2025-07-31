extends Node2D
class_name TaskManager

@export var break_interval: float = 5.0
var tasks: Array[Node] = []

func _ready():
	tasks = get_tree().get_nodes_in_group("task")
	_start_activate_loop()

func _start_activate_loop():
	randomize()
	activate_tasks_loop()

func activate_tasks_loop() -> void:
	await get_tree().create_timer(break_interval).timeout
	_activate_random_task()
	activate_tasks_loop()

func _activate_random_task():
	var available_tasks = []
	for task in tasks:
		# we only activate the tasks where there is no worker assigned
		if not task.task_data.get_is_assigned() and not task.task_data.get_is_broken():
			available_tasks.append(task)

	if available_tasks.is_empty():
		print("No tasks to activate.")
		return

	var random_task = available_tasks[randi() % available_tasks.size()]
	random_task.task_data.progress = 0.0
	SignalBus.task_activated.emit(random_task)
	print("Activated task:", random_task.name)
