extends Node2D
class_name Item

@export var resource: ItemResource
var sprite: Sprite2D;

func _ready():
	assert(resource != null, "resource must be set in the Item node")
	sprite = Sprite2D.new()
	sprite.texture = resource.texture
	add_child(sprite)
