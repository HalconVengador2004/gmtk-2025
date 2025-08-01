@tool
extends Area2D
class_name InteractableComponent

var is_pressed: bool = false

func _ready():
	input_pickable = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_pressed = event.is_pressed()
		if is_pressed:
			get_viewport().set_input_as_handled()
			
			if get_parent().is_in_group("worker"):
				SignalBus.emit_signal("worker_clicked", get_parent())
			# If this is a task, check if there's an overlapping worker
			elif get_parent().is_in_group("task"):
				var overlapping_worker = check_for_overlapping_worker()
				if overlapping_worker:
					SignalBus.emit_signal("worker_clicked", overlapping_worker)
				else:
					SignalBus.emit_signal("task_clicked", get_parent())

func _process(_delta):
	if not is_pressed:
		return
	
	is_pressed = false

func check_for_overlapping_worker():
	var overlapping_areas = get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.get_parent().is_in_group("worker"):
			return area.get_parent()
	
	return null
