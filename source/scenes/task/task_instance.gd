extends Node2D
class_name TaskInstance

@onready var progress_bar = $ProgressBar
var task_data: Task
var timer: Timer

func _ready():
	progress_bar.visible = false
	var smart_object: Node = get_parent()
	if smart_object and smart_object.has_signal("task_started"):
		smart_object.connect("task_started", _on_task_started)

func _on_task_started(task):
	task_data = task
	progress_bar.visible = true
	if timer:
		timer.queue_free()
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = task_data.resource.deadline
	timer.start()

func _process(_delta):
	if task_data:
		var progress = task_data.get_progress()
		var time_to_finish = task_data.resource.time_to_finish
		if timer:
			progress_bar.update_progress_bar(timer.time_left / timer.wait_time)
		if task_data.is_complete():
			progress_bar.visible = false
			task_data = null
