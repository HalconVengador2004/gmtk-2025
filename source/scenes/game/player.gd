extends Node

var selected_worker

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("worker_clicked", select_worker)
	SignalBus.connect("task_clicked", move_worker_to_task)

func select_worker(clicked_worker):
	selected_worker = clicked_worker

func move_worker_to_task(task_instance):
	if not selected_worker:
		return
		
	var previous_task = selected_worker.get_assigned_task()
	if previous_task:
		previous_task.task_data.set_is_assigned(false)
		
	if not task_instance.task_data.is_available():
		print("task is not available")
		return
		
	selected_worker.set_navigation_destination(task_instance.global_position)
	task_instance.task_data.set_is_assigned(true)
	selected_worker.set_assigned_task(task_instance)
