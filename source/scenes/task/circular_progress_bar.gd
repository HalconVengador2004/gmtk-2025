extends ColorRect

var timer

func _ready():
	var original_material = material
	var unique_material = original_material.duplicate() # each progress bar can have its own progress visually
	material = unique_material

func _process(delta):
	if timer:
		visible = true
		material.set("shader_parameter/value", timer.time_left / timer.wait_time)
	else:
		visible = false
