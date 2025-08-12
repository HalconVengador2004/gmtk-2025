extends SmartObject
class_name Gear

@export var multi_sprite: HighlightableMultiSprite
@export var task_resource_2: TaskResource

var gears_sprites: Array[GearSprite]

var is_spinning: bool = true
var task_1: Task
var task_2: Task
var is_task_1_active: bool


func _ready():
	super()
	var nodes: Array[Node] = multi_sprite.get_children()
	for node in nodes:
		if node is GearSprite:
			gears_sprites.append(node)
	
	task_1 = Task.new(task_resource)
	task_2 = Task.new(task_resource_2)

func _process(delta):
	super(delta)
	if is_spinning:
		for gearSprite in gears_sprites:
			gearSprite.rotation += delta * gearSprite.rotation_speed
			
func get_task():
	return task_1 if is_task_1_active else task_2
	
func get_task_resource():
	return task_resource if is_task_1_active else task_resource_2
		
func create_task():
	if randf() > 0.5:
		is_task_1_active = true
		task = task_1
	else:
		is_task_1_active = false
		task = task_2
	super()
		
func _on_task_completed(task_completed: Task):
	super(task_completed)
	if task_completed != task:
		return
	is_spinning = true
		
func _on_task_overdue(task_overdue: Task) -> void:
	super(task_overdue)
	if task_overdue != task:
		return
	is_spinning = false
