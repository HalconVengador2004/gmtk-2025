extends Node2D

class_name SmartObject

@export var task_resource: TaskResource
@onready var interactable_component = $InteractableComponent

var task: Task
var has_task: bool = false
var is_broken: bool = false
var hours_until_can_break: int = 0

func get_task():
	return task

func _ready():
	SignalBus.task_completed.connect(_on_task_completed)
	SignalBus.task_is_overdue.connect(_on_task_overdue)
	task = Task.new(task_resource)
	if not interactable_component:
		push_error("Error: so doesnt have a interactable_component")

func create_task():
	task.reset()
	task.start()
	has_task = true
	SignalBus.task_activated.emit(task)

# Used as default task completetion 
# This needs to be properly overrided if used by a So with special task characteristics
# Eg: it doesn't broke but other get's broken instead etc
func _on_task_completed(task_completed: Task):
	if task_completed != task:
		return
	task.reset()
	has_task = false
	is_broken = false
	
func _on_task_overdue(task_overdue: Task) -> void:
	if task_overdue != task:
		return
	is_broken = true
