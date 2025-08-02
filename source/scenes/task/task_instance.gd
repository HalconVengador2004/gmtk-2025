extends Node2D
class_name TaskInstance

@onready var progress_bar = $ProgressBar

var task_data: Task

func _ready():
	progress_bar.visible = false
	var smart_object: Node = get_parent() 
	if smart_object and smart_object.has_signal("task_started"):
		smart_object.connect("task_started", _on_task_started)

func _on_task_started(task):
	task_data = task
	print("progress_bar visible")
	progress_bar.visible = true

func _process(_delta):
	if task_data:
		var progress = task_data.get_progress()
		var time_to_finish = task_data.resource.time_to_finish
		if time_to_finish > 0:
			progress_bar.size.x = (progress / time_to_finish) * 100
		if task_data.is_complete():
			print("progress_bar not visible")
			progress_bar.visible = false
			task_data = null
