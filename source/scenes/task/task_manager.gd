extends Node2D
class_name TaskManager

@export var create_task_chance: float = 0.5

var smart_objects: Array[Node] = []

func _ready():
	smart_objects = get_tree().get_nodes_in_group("smart_object")

func _physics_process(delta):
	for node in smart_objects:
		var so : SmartObject = node as SmartObject
		if so == null : continue
		if not so.has_task:
			if randf() < create_task_chance * delta:
				so.create_task()
				print("creating task")
