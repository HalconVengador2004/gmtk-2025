@tool
extends Node2D
class_name Item

var resource: ItemResource

@onready var sprite: Sprite2D = $Sprite2D

func setup(item_resource: ItemResource):
	self.resource = item_resource
	name = item_resource.name
	sprite.texture = item_resource.texture

func _ready():
	if not has_node("Sprite2D"):
		var sprite = Sprite2D.new()
		add_child(sprite)
