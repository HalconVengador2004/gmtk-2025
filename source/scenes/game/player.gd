extends Node

var selected_worker

func _ready():
	SignalBus.connect("worker_clicked", select_worker)
	SignalBus.connect("task_clicked", move_worker_to_task)
	SignalBus.connect("storage_clicked", move_worker_to_storage)
	SignalBus.connect("bed_clicked", move_worker_to_bed)

func select_worker(clicked_worker):
	selected_worker = clicked_worker

func move_worker_to_storage(storage_instance):
	if not selected_worker:
		return
	
	selected_worker.set_navigation_destination(storage_instance.global_position)
	selected_worker.set_assigned_storage(storage_instance)

func move_worker_to_bed(bed_instance):
	if not selected_worker:
		return
	
	selected_worker.set_navigation_destination(bed_instance.global_position)
	selected_worker.set_assigned_bed(bed_instance)

func move_worker_to_task(task_instance):
	if not selected_worker:
		return
		
	var previous_task = selected_worker.get_assigned_task()
	if previous_task:
		previous_task.task_data.set_is_assigned(false)
		
	if not task_instance.task_data.get_is_broken():
		print("task is not available")
		return
		
	selected_worker.set_navigation_destination(task_instance.global_position)
	task_instance.task_data.set_is_assigned(true)
	selected_worker.set_assigned_task(task_instance)
