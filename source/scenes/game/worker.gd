extends CharacterBody2D


@export var nav: NavigationAgent2D
@export var speed: float = 100

var finished_moving = false

func _ready():
	if not nav:
		push_warning("Warning: worker doesnt have a navigation agent")

func _physics_process(delta):
	if not finished_moving:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		translate(direction * speed * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("set new position for navigation")
			nav.target_position = get_global_mouse_position()
			finished_moving = false


func _on_navigation_agent_2d_navigation_finished():
	finished_moving = true
