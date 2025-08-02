extends SmartObject

class_name Bed

var is_occupied_by: Worker = null

func _ready():
	interactable_component.clicked.connect(_on_interactable_clicked)

func _on_interactable_clicked(_node):
	if is_occupied_by:
		return
	SignalBus.emit_signal("bed_clicked", self)

func occupy(worker: Worker):
	is_occupied_by = worker

func release():
	is_occupied_by = null
