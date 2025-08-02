class_name Highlightable

var material: Material

func setup(_material: Material):
	var unique_material = _material.duplicate() # each progress bar can have its own progress visually
	material = unique_material
	return unique_material

func add_highlight():
	material.set("shader_parameter/thickness", 2.0)

func remove_highlight():
	material.set("shader_parameter/thickness", 0.0)
