extends Node

var click_area

func _ready():
	click_area = get_parent() as Area2D
	assert(click_area, "Please assign a click area (Area2D) as a parent of this node")
	click_area.input_event.connect(_on_Area2D_input_event)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:	
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("Task clicked!")
			SignalBus.emit_signal("task_clicked", get_parent().get_parent())
			
