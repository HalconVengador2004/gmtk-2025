class_name Task

var resource: TaskResource
var progress: float = 0.0
var is_assigned: bool = false
var is_broken: bool = false

func _init(task_resource: TaskResource):
	self.resource = task_resource

func is_complete() -> bool:
	return progress >= resource.time_to_finish

func is_available() -> bool:
	return not is_complete() and not is_assigned
	
func set_progress(prog):
	progress = prog

func get_progress():
	return progress
	
func set_is_assigned(assigned):
	is_assigned = assigned

func get_is_assigned():
	return is_assigned

func set_is_broken(broken):
	is_broken = broken
	
func get_is_broken():
	return is_broken
