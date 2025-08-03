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
	var small_size = Vector2(64, 64)
	var texture_size = sprite.texture.get_size()
	sprite.scale = small_size / texture_size
	
func clear():
	resource = null
	if sprite:
		sprite.texture = null
