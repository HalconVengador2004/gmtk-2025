extends Node
class_name Storage

@export var item_resource : ItemResource
@export var time_to_grab: float = 1.0

@onready var interactable_component = $InteractableComponent

var is_grabbing: bool = false
var can_collect: bool = false

func _ready():
	interactable_component.connect("clicked", _on_interactable_clicked)

func get_item():
	if is_grabbing:
		return
	
	is_grabbing = true
	var tween = get_tree().create_tween()
	tween.tween_interval(time_to_grab)
	tween.tween_callback(func(): 
		can_collect = true
	)

func collect_item() -> ItemResource:
	if not can_collect:
		return null

	is_grabbing = false
	can_collect = false
	return item_resource

func _on_interactable_clicked(node):
	SignalBus.emit_signal("storage_clicked", self)
