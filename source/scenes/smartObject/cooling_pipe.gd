extends SmartObject

@export var smoke : GPUParticles2D

func _ready():
	super()
	smoke.visible = false

func _on_task_completed(task_completed: Task):
	super(task_completed)
	if task_completed != task:
		return
	smoke.visible = false
		
func _on_task_overdue(task_overdue: Task) -> void:
	super(task_overdue)
	if task_overdue != task:
		return
	smoke.visible = true
