extends Node2D
class_name TaskManager

@export var create_task_chance: float = 0.01
@export var difficulty_multiplier: float = 1.1

var smart_objects: Array[Node] = []

func _ready():
	smart_objects = get_tree().get_nodes_in_group("smart_object")
	SignalBus.connect("day_changed", _increase_difficulty)

func _physics_process(delta):
	for node in smart_objects:
		var so = node as SmartObject
		if not so.has_task:
			if randf() < create_task_chance * delta:
				so.create_task()
				print("creating task")

func _increase_difficulty(_new_day = 0):
	create_task_chance *= difficulty_multiplier
