extends Node2D
class_name Worker

@export var nav: NavigationAgent2D
@export var speed: float = 200

@onready var interactable_component = $InteractableComponent

var finished_moving = false
var assigned_task : Node = null

func set_assigned_task(task_instance):
	assigned_task = task_instance

func get_assigned_task():
	return assigned_task

func get_interactable_component():
	return interactable_component

func set_navigation_destination(pos):
	nav.target_position = pos
	finished_moving = false

func _ready():
	if not nav:
		push_warning("Warning: worker doesnt have a navigation agent")

func _physics_process(delta):
	if not finished_moving:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		translate(direction * speed * delta)


func _on_navigation_agent_2d_navigation_finished():
	finished_moving = true
