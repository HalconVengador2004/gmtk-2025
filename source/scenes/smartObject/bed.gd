extends SmartObject

class_name Bed

func _ready():
	task = null

func _on_interactable_clicked(node):
	if node is Worker:
		node.rest()
