extends Node2D
class_name TaskInstance

@export var task_resource: TaskResource
var task_data: Task
@onready var interactable_component = $InteractableComponent

func _ready():
	task_data = Task.new(task_resource)

func get_interactable_component():
	return interactable_component
