extends Node2D
class_name TaskInstance

@onready var progress_bar = $ProgressBar
@onready var completion_progress_bar = $CompletionProgressBar
@onready var icon = $Sprite2D

var task_data: Task

func _ready():
	progress_bar.visible = false
	completion_progress_bar.visible = false
	icon.visible = false
	
	var smart_object: Node = get_parent()
	smart_object.task_started.connect(_on_task_started)
	SignalBus.task_work_started.connect(_on_task_work_started)
	SignalBus.task_work_stopped.connect(_on_task_work_stopped)

func _on_task_started(task):
	task_data = task
	progress_bar.visible = true
	icon.visible = true
	icon.texture = task.resource.icon

func _process(_delta):
	if task_data:
		var time_left = task_data.resource.deadline - (TimeManager.get_time() - task_data.start_time)
		var progress = time_left / task_data.resource.deadline
		progress_bar.update_progress_bar(progress)
		
		if task_data.is_overdue():
			progress_bar.material.set_shader_parameter("primary_color", Color.RED)
		
		if completion_progress_bar.visible:
			var timeWorking                = task_data.get_time_working()
			var time_to_finish: float      = task_data.resource.time_to_finish
			var completion_progress: float = 0.0
			if time_to_finish > 0:
				completion_progress = timeWorking / time_to_finish
			completion_progress_bar.update_progress_bar(completion_progress)

		if task_data.is_complete():
			progress_bar.visible = false
			completion_progress_bar.visible = false
			icon.visible = false
			task_data = null

func _on_task_work_started(task_instance) -> void:
	if task_instance == self:
		if completion_progress_bar.visible:
			return
		icon.visible = true	
		completion_progress_bar.visible = true
		completion_progress_bar.material.set_shader_parameter("primary_color", Color.GREEN)

func _on_task_work_stopped(task_instance):
	if task_instance == self:
		if task_data and not task_data.is_complete():
			# Keep the completion bar visible to show partial progress
			pass
		else:
			icon.visible = false
			completion_progress_bar.visible = false
