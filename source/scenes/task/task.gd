class_name Task

var resource: TaskResource
var progress: float = 0.0
var is_assigned: bool = false
var start_time: float = 0.0

func _init(task_resource: TaskResource):
	self.resource = task_resource

func is_overdue() -> bool:
	if is_assigned:
		return Time.get_ticks_msec() - start_time > resource.deadline * 1000
	return false

func is_complete() -> bool:
	return progress >= resource.time_to_finish
	
func set_progress(prog):
	progress = prog

func get_progress():
	return progress
	
func set_is_assigned(assigned):
	is_assigned = assigned
	if is_assigned:
		start_time = Time.get_ticks_msec()

func get_is_assigned():
	return is_assigned
