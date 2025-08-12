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
@export var initial_energy :float = 100

@onready var interactable_component = $InteractableComponent
@onready var progress_bar = $ProgressBar
@onready var anim_sprite = $HighlightableSprite

enum States {ACTION, BED, CLIMB, GRAB, IDLE, RUN, RUN_TIRED, THROW, TIRED, CHARGING}
var state: States = States.IDLE
var previous_state: States = States.IDLE

var energy: float
var is_climbing: bool = false
var is_resting: bool = false
var is_throwing: bool = false
var finished_moving: bool = true
var is_walking_towards_a_task: bool = false
var assigned_task : Node = null
var assigned_storage: Storage = null
var assigned_bed: Bed = null
var assigned_hamster_wheel: Node = null
var last_facing_left: bool = false


@onready var worker_sfx_manager: Node = $WorkerSFXManager

func set_assigned_task(task_instance):
	clear_assignments()
	assigned_task = task_instance
	worker_sfx_manager.play_worker_assign_sound()

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
	hamster_wheel_instance.occupy(self)
	worker_sfx_manager.play_worker_assign_sound()


func clear_assignments():
	if assigned_task and assigned_task.task_data:
		assigned_task.task_data.set_is_assigned(false)
		worker_sfx_manager.play_worker_complete_sound()
		if state == States.ACTION:
			SignalBus.task_work_stopped.emit(assigned_task)
	assigned_task = null
	
	assigned_storage = null
	
	if assigned_bed:
		SignalBus.worker_stopped_sleeping.emit(assigned_bed)
		assigned_bed.release()
		assigned_bed = null
	
	if assigned_hamster_wheel:
		assigned_hamster_wheel.release()
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
	energy = initial_energy
	if not nav:
		push_warning("Warning: worker doesnt have a navigation agent")
	if not interactable_component:
		push_warning("Warning: worker doesnt have a navigation agent")
	state = States.IDLE
	anim_sprite.play("idle")

func _physics_process(delta):
	_update_energy(delta)
	
	if state == States.ACTION:
		if assigned_task and assigned_task.task_data:
			var task_data: Task = assigned_task.task_data
			task_data.time_working += delta
			worker_sfx_manager.play_worker_work_sound()
			
			if task_data.is_complete():
				var task_instance = assigned_task
				var completed_task_data = task_instance.task_data
				
				worker_sfx_manager.stop_worker_work_sound()
				
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
	
	if state == States.ACTION or is_resting or state == States.CHARGING:
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
		if not assigned_storage.is_grabbing and (not has_item() or assigned_storage is TrashCan):
			assigned_storage.get_item()
		if assigned_storage.can_collect:
			if assigned_storage is TrashCan:
				clear_carried_item()
				assigned_storage.collect_item()
				assigned_storage = null
			else:
				var collected_resource: ItemResource = assigned_storage.collect_item()
				if collected_resource and item:
					item.init(collected_resource)
					item.visible = true
				assigned_storage = null

func has_item() -> bool:
	return item != null and item.resource != null

func _on_task_work_stopped(task_instance : TaskInstance):
	if not task_instance.task_data.is_complete():
		return
	if not item:
		return
	if task_instance.task_data.resource.required_item == item.resource:
		clear_carried_item()

func _update_energy(delta: float) -> void:
	if is_resting:
		energy += energy_recovering_per_second * delta
		if energy >= max_energy:
			is_resting = false
			energy = max_energy
			if assigned_bed:
				SignalBus.worker_stopped_sleeping.emit(assigned_bed)
				assigned_bed.release()
				assigned_bed = null
	else:
		energy -= energy_spent_per_second * delta
		if energy < 0:
			energy = 0
	update_progress_bar()
	
func _determine_state():
	update_is_climbing()
	
	if state == States.ACTION or state == States.CHARGING:
		return
	
	if is_resting:
		state = States.BED
		return
	
	if assigned_storage and assigned_storage.is_grabbing:
		state = States.GRAB
		return
		
	if item and is_throwing:
		state = States.THROW
		return
		
	if is_climbing:
		state = States.CLIMB
		return

	if not finished_moving:
		if energy < energy_threshold:
			state = States.RUN_TIRED
		else:
			state = States.RUN
		return

	if assigned_task and finished_moving and is_walking_towards_a_task:
		state = States.ACTION
		return

	if energy < energy_threshold:
		state = States.TIRED
	else:
		state = States.IDLE
			
func _update_anim():
	if previous_state != state:
		match state:
			States.IDLE:
				_play_animation("idle")
			States.RUN:
				_play_animation("run")
			States.RUN_TIRED:
				_play_animation("run_tired")
			States.TIRED:
				_play_animation("tired")
			States.ACTION:
				_play_animation("action")
			States.BED:
				SignalBus.worker_sleeping.emit(assigned_bed)
				_play_animation("bed")
			States.GRAB:
				_play_animation("grab")
			States.THROW:
				_play_animation("throw")
			States.CLIMB:
				_play_animation("climb")
			States.CHARGING:
				_play_animation("charging")
				SignalBus.worker_charging.emit()
		if previous_state == States.CHARGING:
			SignalBus.worker_stopped_charging.emit()

		
	previous_state = state

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
		state = States.ACTION
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
		
func update_is_climbing():
	is_climbing = false
	var stairs = get_tree().get_nodes_in_group("stairs")
	var overlapping = interactable_component.get_overlapping_areas()
	for area in overlapping:
		if area.is_in_group("stair"):
			is_climbing = true
			return

func is_selected():
	worker_sfx_manager.play_worker_select_sound()
