extends SmartObject

class_name Bed

var is_occupied_by: Worker = null

func _ready():
	pass

func occupy(worker: Worker):
	is_occupied_by = worker

func release():
	is_occupied_by = null
