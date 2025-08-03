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
@export var vertical_offset: float = 0
@export var sprite_scale: Vector2 = Vector2.ONE

@onready var interactable_component = $InteractableComponent
@onready var sprite = $HighlightableSprite

var is_grabbing: bool = false
var can_collect: bool = false

func _ready():
	sprite.texture = sprite_texture

func _process(_delta):
	sprite.offset.y = vertical_offset
	sprite.scale = sprite_scale
	

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
