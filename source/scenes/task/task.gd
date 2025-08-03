class_name Task

var resource: TaskResource
var time_working: float = 0.0
var is_assigned: bool   = false
var start_time: float = 0.0
var is_overdue_checked: bool = false

func _init(task_resource: TaskResource):
	self.resource = task_resource

func reset():
	time_working = 0.0
	is_assigned = false
	start_time = 0.0
	is_overdue_checked = false

func is_overdue() -> bool:
	if is_overdue_checked:
		var overdue = TimeManager.get_time() - start_time > resource.deadline
		if overdue:
			is_overdue_checked = true
			SignalBus.task_is_overdue.emit(self)
		return overdue
	return false

func is_complete() -> bool:
	return time_working >= resource.time_to_finish

func get_time_working():
	return time_working
	
func set_is_assigned(assigned):
	is_assigned = assigned

func get_is_assigned():
	return is_assigned
