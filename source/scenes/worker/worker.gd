extends Node2D
class_name Worker

@export var nav: NavigationAgent2D
@export var anim_sprite: HighlightableAnimatedSprite
@export var speed: float = 200
@export var item: Item
@export var max_energy: float = 100.0
@export var tired_speed_multiplier: float = 0.3
@export var energy_threshold: float = 20.0

@onready var interactable_component = $InteractableComponent

enum States {IDLE, RUNNING, RUNNING_TIRED, TIRED, WORKING}

var energy: float
var finished_moving = false
var assigned_task : Node = null
var assigned_storage: Storage = null
var is_walking_towards_a_task: bool = false

func set_assigned_task(task_instance):
	if assigned_task and assigned_task.task_data:
		assigned_task.task_data.set_is_assigned(false)
	assigned_task = task_instance
	assigned_storage = null

func set_assigned_storage(storage_instance: Storage):
	if assigned_task and assigned_task.task_data:
		assigned_task.task_data.set_is_assigned(false)
	assigned_storage = storage_instance
	assigned_task = null

func get_assigned_task():
	return assigned_task

func get_item():
	return item
	
func set_is_walking_towards_a_task(walking):
	is_walking_towards_a_task = walking

func get_interactable_component():
	return interactable_component

func set_navigation_destination(pos):
	nav.target_position = pos
	finished_moving = false

func _ready():
	nav.path_desired_distance = 4
	energy = max_energy
	if not nav:
		push_warning("Warning: worker doesnt have a navigation agent")
	if not interactable_component:
		push_warning("Warning: worker doesnt have a navigation agent")
	interactable_component.connect("clicked", _on_interactable_clicked)

func _physics_process(delta):
	energy -= delta
	var current_speed = speed
	if energy < energy_threshold:
		current_speed *= tired_speed_multiplier

	if not finished_moving:
		var direction: Vector2 = (nav.get_next_path_position() - global_position).normalized()
		var velocity = direction * current_speed
		global_position += velocity * delta
		
	elif finished_moving and assigned_storage:
		if not assigned_storage.is_grabbing:
			assigned_storage.get_item()
		if assigned_storage.can_collect:
			var collected_resource: ItemResource = assigned_storage.collect_item()
			if collected_resource:
				item.init(collected_resource)
				assigned_storage = null
			elif assigned_storage is TrashCan:
				clear_carried_item()
				assigned_storage = null

func rest():
	energy = max_energy
	
func clear_carried_item():
	if item:
		item.clear()

func work():
	print("Worker", self, "is working")

func _on_navigation_agent_2d_navigation_finished():
	finished_moving = true
	if is_walking_towards_a_task:
		work()

func _on_interactable_clicked(node):
	SignalBus.emit_signal("worker_clicked", self)
