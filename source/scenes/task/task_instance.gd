extends Node2D
class_name TaskInstance

@export var progress_bar: ColorRect

var task_data: Task

func _ready():
	var smart_object: Node = get_parent() 
	if smart_object and smart_object.has_signal("task_started"):
		smart_object.connect("task_started", _on_task_started)

func _on_task_started(task):
	task_data = task

func _process(_delta):
	if task_data:
		var progress = task_data.get_progress()
		var time_to_finish = task_data.resource.time_to_finish
		if time_to_finish > 0:
			progress_bar.size.x = (progress / time_to_finish) * 100
