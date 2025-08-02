class_name Highlightable

var material: Material

func setup(_material: Material):
	material = _material.duplicate()
	return material

func add_highlight():
	material.set("shader_parameter/thickness", 1.0)

func remove_highlight():
	material.set("shader_parameter/thickness", 0.0)
