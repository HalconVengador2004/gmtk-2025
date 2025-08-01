extends Node
class_name Storage

@export var item_resource : ItemResource
@export var cooldown_time : float = 1
@export var areaToInteract : Area2D #Area define how close an worker need to be to get item 

var is_cooldown : bool = false
var current_time : float = 0

# Todo: How should I make worker spawn item?
func spawn_item():
	if is_cooldown:
		return
		
	var item : Item = Item.new()
	item.resource = item_resource
	item.add_to_group("item")
	
	is_cooldown = true
	current_time = cooldown_time
	
func _process(delta: float) -> void:
	if is_cooldown:
		current_time += delta
		if current_time > cooldown_time:
			current_time = 0
			is_cooldown = false
			