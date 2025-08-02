extends Node2D
class_name Worker

@export var nav: NavigationAgent2D
@export var speed: float = 200
@export var item: Item
@export var max_energy: float = 100.0
@export var tired_speed_multiplier: float = 0.5
@export var energy_threshold: float = 20.0
@export var energy_recovering_per_second = 5
@export var energy_spent_per_second = 1

@onready var interactable_component = $InteractableComponent
@onready var progress_bar = $ProgressBar

var energy: float


# worker state
var is_resting = false
var finished_moving = false
var assigned_task : Node = null
var assigned_storage: Storage = null
var assigned_bed: Bed = null

func set_assigned_task(task_instance):
	assigned_task = task_instance
	assigned_storage = null
	assigned_bed = null
	if is_resting:
		is_resting = false

func set_assigned_storage(storage_instance: Storage):
	assigned_storage = storage_instance
	assigned_task = null
	assigned_bed = null
	if is_resting:
		is_resting = false

func set_assigned_bed(bed_instance: Bed):
	assigned_bed = bed_instance
	assigned_storage = null
	assigned_task = null
	bed_instance.occupy(self)

func get_assigned_task():
	return assigned_task

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
	if is_resting:
		energy += energy_recovering_per_second * delta
		if energy >= max_energy:
			is_resting = false
			energy = max_energy
			if assigned_bed:
				assigned_bed.release()
				assigned_bed = null
		update_progress_bar()
		return
	
	energy -= energy_spent_per_second * delta
	update_progress_bar()
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

func rest():
	is_resting = true
	finished_moving = true
	
func update_progress_bar():
	var energy_percentage = energy / max_energy
	if progress_bar and progress_bar.material:
		progress_bar.material.set_shader_parameter("progress", energy_percentage)
		progress_bar.material.set_shader_parameter("threshold", energy_threshold / max_energy)

func clear_carried_item():
	if item:
		item.clear()


func _on_navigation_agent_2d_navigation_finished():
	finished_moving = true
	if assigned_bed:
		rest()

func _on_interactable_clicked(node):
	SignalBus.emit_signal("worker_clicked", self)
