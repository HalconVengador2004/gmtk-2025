extends Node2D
class_name TaskInstance

@export var progress_bar_offset: Vector2 = Vector2(0, 0)
@export var task_resource: TaskResource
@export var progress_bar: ColorRect
var task_data: Task
@onready var interactable_component = $InteractableComponent
var timer: Timer
signal break_random_task()


func _ready():
	task_data = Task.new(task_resource)
	interactable_component.connect("clicked", _on_interactable_clicked)

func get_interactable_component():
	return interactable_component

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
	
func break_task():
	if not timer:
		timer = Timer.new()
		add_child(timer)
	timer.wait_time = task_data.resource.time_to_finish
	timer.start()
	timer.timeout.connect(func():
		emit_signal("break_random_task")
	)
	progress_bar.timer = timer
	task_data.set_is_broken(true)
