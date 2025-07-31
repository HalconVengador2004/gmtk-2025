extends Sprite2D

func _ready():
	var original_material = material
	var unique_material = original_material.duplicate()
	material = unique_material
	
	_connect_signals()

func _connect_signals():
	SignalBus.task_clicked.connect(highlight)
	SignalBus.worker_clicked.connect(highlight)
	
func highlight(entity):
	if get_parent() == entity:
		material.set("shader_parameter/thickness", 1.0)
	else:
		material.set("shader_parameter/thickness", 0.0)
