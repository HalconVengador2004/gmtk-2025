@tool
extends Resource
class_name TaskResource

@export var required_item: ItemResource
@export var time_to_finish: float = 5.0 # Time in seconds
@export var deadline: float = 30.0 # Time in seconds
@export var icon: Texture2D
