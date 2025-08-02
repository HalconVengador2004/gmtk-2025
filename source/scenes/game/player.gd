extends Node

var selected_worker: Worker

func _ready():
	SignalBus.connect("worker_clicked", select_worker)
	SignalBus.connect("task_clicked_instance", move_worker_to_task)
	SignalBus.connect("storage_clicked", move_worker_to_storage)
	SignalBus.connect("bed_clicked", move_worker_to_bed)

func select_worker(clicked_worker):
	if selected_worker and selected_worker != clicked_worker:
		selected_worker.anim_sprite.remove_highlight()
	selected_worker = clicked_worker
	selected_worker.anim_sprite.add_highlight()

func move_worker_to_storage(storage_instance):
	if not selected_worker:
		return
	
	selected_worker.set_navigation_destination(storage_instance.global_position)
	selected_worker.set_assigned_storage(storage_instance)
	selected_worker.set_is_walking_towards_a_task(false)

func move_worker_to_bed(bed_instance):
	if not selected_worker:
		return

	selected_worker.set_navigation_destination(bed_instance.global_position)
	selected_worker.set_assigned_bed(bed_instance)	
	

func move_worker_to_task(task_instance: TaskInstance):
	if not selected_worker or not task_instance:
		return
		
	if selected_worker.assigned_bed:
		selected_worker.assigned_bed = null
	
	if selected_worker.assigned_storage:
		selected_worker.assigned_storage = null
		
	var previous_task = selected_worker.get_assigned_task()
	if previous_task:
		previous_task.task_data.set_is_assigned(false)
		
	if task_instance.task_data.get_is_assigned():
		print("task is not available")
		return

	var worker_item = selected_worker.get_item()
	if not worker_item or not worker_item.resource:
		print("Worker has no item or item has no resource")
		return

	if task_instance.task_data.resource.required_item != worker_item.resource:
		return

	print("Sending worker to:", task_instance)
	selected_worker.set_navigation_destination(task_instance.global_position)
	task_instance.task_data.set_is_assigned(true)
	selected_worker.set_assigned_task(task_instance)
	selected_worker.set_is_walking_towards_a_task(true)
