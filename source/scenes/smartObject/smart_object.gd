extends Node2D

class_name SmartObject

signal task_started(task)

@export var task_resource: TaskResource
@onready var interactable_component = $InteractableComponent

var task: Task
var has_task: bool = false
var is_broken: bool = false

func get_task():
	return task

func _ready():
	task = Task.new(task_resource)
	if not interactable_component:
		push_warning("Warning: so doesnt have a interactable_component")
	interactable_component.connect("clicked", _on_interactable_clicked)

func create_task():
	task = Task.new(task_resource)
	has_task = true
	emit_signal("task_started", task)

func _physics_process(_delta):
	if has_task and task.is_overdue() and not task.is_complete():
		is_broken = true

func _on_interactable_clicked(_node):
	SignalBus.emit_signal("task_clicked", task, self)
