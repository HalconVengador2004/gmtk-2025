class_name Task

var resource: TaskResource
var progress: float = 0.0

func _init(task_resource: TaskResource):
	self.resource = task_resource

func is_complete() -> bool:
	return progress >= resource.time_to_finish
