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
	has_task = true

func _physics_process(_delta):
	if has_task and task.is_overdue() and not task.is_complete():
		is_broken = true

func _on_interactable_clicked(_node):
	if is_broken:
		var fix_task_resource = TaskResource.new()
		fix_task_resource.time_to_finish = 10
		var fix_task = Task.new(fix_task_resource)
		SignalBus.emit_signal("task_clicked", fix_task, self)
		emit_signal("task_started", fix_task)
	else:
		SignalBus.emit_signal("task_clicked", task, self)
		emit_signal("task_started", task)
