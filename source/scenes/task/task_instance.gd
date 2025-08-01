extends Node2D
class_name TaskInstance

@export var task_resource: TaskResource
@export var progress_bar: ColorRect
var task_data: Task
@onready var interactable_component = $InteractableComponent
var timer: Timer


func _ready():
	task_data = Task.new(task_resource)
	SignalBus.task_activated.connect(_start_timer)
	interactable_component.connect("clicked", _on_interactable_clicked)

func get_interactable_component():
	return interactable_component

func _start_timer(task):
	print(task, self)
	if task == self:
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = task_data.resource.time_to_finish
		timer.start()
		timer.timeout.connect(break_task)
		progress_bar.timer = timer

func break_task():
	task_data.set_is_broken(true)
	print("task broken")

func _on_interactable_clicked(_node):
	var overlapping = check_for_overlapping_worker()
	if overlapping:
		SignalBus.emit_signal("worker_clicked", overlapping)
	else:
		SignalBus.emit_signal("task_clicked", self)

func check_for_overlapping_worker():
	var overlapping_areas = interactable_component.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.get_parent().is_in_group("worker"):
			return area.get_parent()
	
	return null
