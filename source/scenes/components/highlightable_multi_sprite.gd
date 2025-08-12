extends HighlightableSprite
class_name HighlightableMultiSprite

func add_highlight():
	var children = get_children()
	for child in children:
		if child is HighlightableSprite:
			child.add_highlight()

func remove_highlight():
	var children = get_children()
	for child in children:
		if child is HighlightableSprite:
			child.remove_highlight()
