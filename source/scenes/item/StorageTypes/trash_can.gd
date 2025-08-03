@tool
extends Storage
class_name TrashCan

func collect_item() -> ItemResource:
	if not can_collect:
		return null
	is_grabbing = false
	can_collect = false
	return null
