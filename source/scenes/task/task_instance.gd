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
