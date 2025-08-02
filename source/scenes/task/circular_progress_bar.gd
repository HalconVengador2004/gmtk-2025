extends ColorRect
class_name circular_progress_bar

func _ready():
	var original_material = material
	var unique_material = original_material.duplicate() # each progress bar can have its own progress visually
	material = unique_material
	

func update_progress_bar(new_value):
	material.set("shader_parameter/value", new_value)
