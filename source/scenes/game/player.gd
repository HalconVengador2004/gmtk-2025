# Player.gd - Manages player interactions, including selection and commands.
#
# Selection Logic:
# - The player can select one worker at a time.
# - Hovering over objects highlights them, with workers having selection priority.
# - Left-clicking selects an object. If a worker is already selected, 
#   clicking a smart object or storage assigns a task to the worker.
# - Right-clicking deselects the current worker.
#
# Highlighting Rules:
# - Selected workers remain highlighted.
# - Other objects are highlighted only when hovered over.
#
# Priority System:
# - When multiple objects overlap, the one with the highest priority is selected.
# - Priority Order: Worker > Smart Object > Storage.

extends Node2D

var selected_worker: Worker
var hovered_nodes: Array = []

func _ready():
	var interactables = get_tree().get_nodes_in_group("interactable")
	for interactable in interactables:
		interactable.hovered.connect(on_hovered)
		interactable.unhovered.connect(on_unhovered)
		interactable.selected.connect(on_selected)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if selected_worker:
			selected_worker.get_node("HighlightableSprite").remove_highlight()
			selected_worker = null

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if selected_worker and len(hovered_nodes) == 0:
			selected_worker.move_to_position(get_global_mouse_position())

func on_hovered(node):
	if not node in hovered_nodes:
		hovered_nodes.append(node)
	update_hover_highlight()

func on_unhovered(node):
	if node in hovered_nodes:
		hovered_nodes.erase(node)
	
	if node != selected_worker:
		var highlightable = node.get_node_or_null("HighlightableSprite")
		if highlightable:
			highlightable.remove_highlight()
	
	update_hover_highlight()

func on_selected(_node):
	var target = get_highest_priority_node(hovered_nodes)
	if not target:
		return

	if target is Worker:
		if selected_worker:
			selected_worker.get_node("HighlightableSprite").remove_highlight()
		selected_worker = target
		selected_worker.get_node("HighlightableSprite").add_highlight()
	elif selected_worker:
		if target.is_in_group("storage"):
			move_worker_to_storage(target)
		elif target.is_in_group("smart_object"):
			if target is Bed:
				move_worker_to_bed(target)
			elif target is HamsterWheel:
				if target.has_task:
					var task_instance = target.get_node_or_null("TaskInstance")
					if task_instance:
						move_worker_to_task(task_instance)
				else:	
					move_worker_to_hamster_wheel(target)
			else:
				var task_instance = target.get_node_or_null("TaskInstance")
				if task_instance:
					move_worker_to_task(task_instance)

func update_hover_highlight():
	var highest_priority_node = get_highest_priority_node(hovered_nodes)
	for node in get_tree().get_nodes_in_group("interactable"):
		var parent = node.get_parent()
		if parent != selected_worker and parent != highest_priority_node:
			var highlightable = parent.get_node_or_null("HighlightableSprite")
			if highlightable:
				highlightable.remove_highlight()

	if highest_priority_node and highest_priority_node != selected_worker:
		var highlightable = highest_priority_node.get_node_or_null("HighlightableSprite")
		if highlightable:
			highlightable.add_highlight()

# if there is more than on node being hover 			
func get_highest_priority_node(nodes: Array):
	var worker = null
	var smart_object = null
	var storage = null

	for node in nodes:
		if node is Worker:
			worker = node
		elif node.is_in_group("smart_object"):
			smart_object = node
		elif node.is_in_group("storage"):
			storage = node
	
	if worker:
		return worker
	if smart_object:
		return smart_object
	if storage:
		return storage
	
	return null

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

func move_worker_to_hamster_wheel(hamster_wheel_instance):
	if not selected_worker:
		return

	selected_worker.set_navigation_destination(hamster_wheel_instance.global_position)
	selected_worker.set_assigned_hamster_wheel(hamster_wheel_instance)
	
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

	if task_instance.task_data.resource.required_item:	
		var worker_item = selected_worker.get_item()
		if not worker_item:
			print("Worker has no item")
			return
		if task_instance.task_data.resource.required_item != worker_item.resource:
			return

	print("Sending worker to:", task_instance)
	selected_worker.set_navigation_destination(task_instance.global_position)
	task_instance.task_data.set_is_assigned(true)
	selected_worker.set_assigned_task(task_instance)
	selected_worker.set_is_walking_towards_a_task(true)
