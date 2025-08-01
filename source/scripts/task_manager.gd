extends Node2D
class_name TaskManager

@export var break_interval: float = 6.0
var tasks: Array[Node] = []
var timer: Timer

func _ready():
	tasks = get_tree().get_nodes_in_group("task")
	for task in tasks:
		task.connect("break_random_task", _break_random_task)
	start_default_breaking_timer()

func _break_random_task():
	var breakable_tasks = []
	for task in tasks:
		if not task.task_data.get_is_broken():
			breakable_tasks.append(task)
	if not breakable_tasks.is_empty():
		var pick = breakable_tasks[randi() % breakable_tasks.size()]
		pick.break_task()
		print("breaking task")
	else:
		print("YOU LOST")

func start_default_breaking_timer() -> void:
	if not timer:
		timer = Timer.new()
		add_child(timer)
	timer.wait_time = break_interval
	timer.start()
	timer.timeout.connect(_break_random_task)
