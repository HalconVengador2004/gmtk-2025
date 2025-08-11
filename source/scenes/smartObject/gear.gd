extends SmartObject
class_name Gear

@export var multi_sprite: HighlightableMultiSprite
@export var task_resource_2: TaskResource
@export var rotation_speed: float = 1.0

var children: Array[Node]
var task_1: Task
var task_2: Task

func _ready():
	super()
	children = multi_sprite.get_children()
	task_1 = Task.new(task_resource)
	task_2 = Task.new(task_resource_2)

func _process(delta):
	super(delta)
	for child in children:
		child.rotation += delta * rotation_speed
		
func get_task_resource():
	if randf() > 0.5:
		return task_resource_2
	else:
		return super()
