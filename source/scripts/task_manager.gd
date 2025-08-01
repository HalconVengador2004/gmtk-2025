extends Node2D
class_name TaskManager

@export var initial_break_interval: float = 10.0
@export var interval_decay_factor: float = 0.99
var tasks: Array[Node] = []
var timer: Timer
var current_break_interval: float

func _ready():
	tasks = get_tree().get_nodes_in_group("task")
	for task in tasks:
		task.connect("break_random_task", _break_random_task)
	current_break_interval = initial_break_interval
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
		#TODO actually losing
		print("YOU LOST")

func start_default_breaking_timer():
	if not timer:
		timer = Timer.new()
		add_child(timer)
	timer.wait_time = initial_break_interval
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	
func increase_difficulty():
	current_break_interval *= interval_decay_factor
	
func _on_timer_timeout():
	_break_random_task()
	increase_difficulty()
	# restart with new break interval
	timer.wait_time = current_break_interval
	timer.start()
