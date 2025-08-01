@tool
extends ColorRect

@export var offset: Vector2 = Vector2(0, 0)
var camera: Camera2D
var timer

func _ready():
	camera = get_viewport().get_camera_2d()
	var original_material = material
	var unique_material = original_material.duplicate()
	material = unique_material

func _process(delta):
	if timer:
		visible = true
		material.set("shader_parameter/value", timer.time_left / timer.wait_time)
	else:
		visible = false

	if camera == null:
		return

	var sprite = get_parent() as Sprite2D
	if sprite == null:
		return

	# Get sprite center in world coordinates
	var sprite_center = sprite.global_position + sprite.get_rect().size * sprite.scale * 0.5

	var screen_pos = camera.global_transform.origin + (sprite_center - camera.global_position)
	global_position = screen_pos

	
