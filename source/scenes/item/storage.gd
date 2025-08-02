@tool
extends Node2D
class_name Storage

@export var sprite_texture: Texture2D:
	set(new_texture):
		sprite_texture = new_texture
		if sprite:
			sprite.texture = sprite_texture

@export var item_resource : ItemResource
@export var time_to_grab: float = 1.0

@onready var interactable_component = $InteractableComponent
@onready var sprite = $HighlightableSprite

var is_grabbing: bool = false
var can_collect: bool = false

func _ready():
	interactable_component.connect("clicked", _on_interactable_clicked)
	sprite.texture = sprite_texture

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

func _on_interactable_clicked(_node):
	var overlapping = check_for_overlapping_worker()
	if overlapping:
		SignalBus.emit_signal("worker_clicked", overlapping)
	else:
		SignalBus.emit_signal("storage_clicked", self)

func check_for_overlapping_worker():
	var overlapping_areas = interactable_component.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.get_parent().is_in_group("worker"):
			return area.get_parent()
	
	return null
