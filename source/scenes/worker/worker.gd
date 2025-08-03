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
@onready var anim_sprite = $HighlightableSprite

enum States {IDLE, RUNNING, RUNNING_TIRED, TIRED, WORKING, SLEEPING, CHARGING}
var state: States = States.IDLE

var energy: float

# worker state
var is_resting: bool = false
var finished_moving: bool = true
var is_walking_towards_a_task: bool = false
var assigned_task : Node = null
var assigned_storage: Storage = null
var assigned_bed: Bed = null
var assigned_hamster_wheel: Node = null
var last_facing_left: bool = false

func set_assigned_task(task_instance):
	clear_assignments()
	assigned_task = task_instance

func set_assigned_storage(storage_instance: Storage):
	clear_assignments()
	assigned_storage = storage_instance

func set_assigned_bed(bed_instance: Bed):
	clear_assignments()
	assigned_bed = bed_instance
	bed_instance.occupy(self)

func set_assigned_hamster_wheel(hamster_wheel_instance):
	clear_assignments()
	assigned_hamster_wheel = hamster_wheel_instance

func clear_assignments():
	if assigned_task and assigned_task.task_data:
		assigned_task.task_data.set_is_assigned(false)
		if state == States.WORKING:
			SignalBus.task_work_stopped.emit(assigned_task)
		
	assigned_task = null
	
	assigned_storage = null
	
	if assigned_bed:
		assigned_bed.release()
		assigned_bed = null

	assigned_hamster_wheel = null
	
	if is_resting:
		is_resting = false
	
	is_walking_towards_a_task = false

func get_assigned_task():
	return assigned_task

func get_item():
	return item
	
func set_is_walking_towards_a_task(walking):
	is_walking_towards_a_task = walking

func get_interactable_component():
	return interactable_component

func move_to_position(pos):
	clear_assignments()
	set_navigation_destination(pos)

func set_navigation_destination(pos):
	nav.target_position = pos
	finished_moving = false

func _ready():
	SignalBus.task_work_stopped.connect(_on_task_work_stopped)
	progress_bar.material = progress_bar.material.duplicate()
	nav.path_desired_distance = 4
	energy = max_energy
	if not nav:
		push_warning("Warning: worker doesnt have a navigation agent")
	if not interactable_component:
		push_warning("Warning: worker doesnt have a navigation agent")
	state = States.IDLE
	anim_sprite.play("idle")

func _physics_process(delta):
	_update_energy(delta)
	
	if state == States.WORKING:
		if assigned_task and assigned_task.task_data:
			var task_data: Task = assigned_task.task_data
			task_data.time_working += delta
			
			if task_data.is_complete():
				var task_instance = assigned_task
				var completed_task_data = task_instance.task_data
				
				clear_assignments()
				SignalBus.task_completed.emit(completed_task_data)
				state = States.IDLE
		else:
			state = States.IDLE
	elif state == States.CHARGING:
		if assigned_hamster_wheel:
			assigned_hamster_wheel.charge(delta)
		else:
			state = States.IDLE

	_determine_state()
	_update_anim()
	
	if state == States.WORKING or is_resting or state == States.CHARGING:
		return
		
	var current_speed = speed
	if energy < energy_threshold:
		current_speed *= tired_speed_multiplier
	
	if finished_moving:
		anim_sprite.flip_h = last_facing_left

	if not finished_moving:
		var direction: Vector2 = (nav.get_next_path_position() - global_position).normalized()
		var velocity = direction * current_speed
		global_position += velocity * delta
		if abs(velocity.x) > 0.01:
			last_facing_left = velocity.x > 0
			anim_sprite.flip_h = last_facing_left
		
	elif finished_moving and assigned_storage:
		if not assigned_storage.is_grabbing:
			assigned_storage.get_item()
		if assigned_storage.can_collect:
			var collected_resource: ItemResource = assigned_storage.collect_item()
			if collected_resource:
				item.init(collected_resource)
				item.visible = true
				assigned_storage = null
			elif assigned_storage is TrashCan:
				clear_carried_item()
				assigned_storage = null

func _on_task_work_stopped(task_instance : TaskInstance):
	if not task_instance.task_data.is_complete():
		return
	if not item:
		return
	if task_instance.task_data.resource.required_item == item.resource:
		item.visible = false

func _update_energy(delta: float) -> void:
	if is_resting:
		energy += energy_recovering_per_second * delta
		if energy >= max_energy:
			is_resting = false
			energy = max_energy
			if assigned_bed:
				assigned_bed.release()
				assigned_bed = null
	else:
		energy -= energy_spent_per_second * delta
		if energy < 0:
			energy = 0
	update_progress_bar()
	
func _determine_state():
	if state == States.WORKING or state == States.SLEEPING or state == States.CHARGING:
		return

	if is_resting:
		state = States.SLEEPING
	elif not finished_moving:
		if energy < energy_threshold:
			state = States.RUNNING_TIRED
		else:
			state = States.RUNNING
	else:
		if energy < energy_threshold:
			state = States.TIRED
		else:
			state = States.IDLE
			
func _update_anim():
	match state:
		States.IDLE:
			_play_animation("idle")
		States.RUNNING:
			_play_animation("run")
		States.RUNNING_TIRED:
			_play_animation("run_tired")
		States.TIRED:
			_play_animation("tired")
		States.WORKING:
			_play_animation("work")
		States.SLEEPING:
			_play_animation("sleeping")
		States.CHARGING:
			_play_animation("run")

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

func work():
	if assigned_task:
		state = States.WORKING
		SignalBus.task_work_started.emit(assigned_task)

func _on_navigation_agent_2d_navigation_finished():
	finished_moving = true
	if assigned_bed:
		rest()
	if is_walking_towards_a_task:
		work()
	if assigned_hamster_wheel:
		state = States.CHARGING

func _play_animation(anim_name: String) -> void:
	if anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)
