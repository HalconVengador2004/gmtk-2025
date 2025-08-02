extends Sprite2D
class_name HighlightableSprite

func _ready():
	var original_material = material
	var unique_material = original_material.duplicate()
	material = unique_material
	
func add_highlight():
	material.set("shader_parameter/thickness", 1.0)
	
func remove_highlight():
	material.set("shader_parameter/thickness", 0.0)
