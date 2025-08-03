extends Node2D
class_name Item

@export var resource: ItemResource
var sprite: Sprite2D;

func _ready():
	sprite = Sprite2D.new()
	add_child(sprite)
	if resource:
		init(resource)

func init(new_resource: ItemResource):
	resource = new_resource
	sprite.texture = resource.texture
	
func clear():
	resource = null
	if sprite:
		sprite.texture = null
