extends SmartObject
class_name Gear
@export var multi_sprite : HighlightableMultiSprite
@export var rotation_speed : float = 1

var children : Array[Node]

func _ready():
	super()
	children = multi_sprite.get_children()
	
func _process(delta):
	super(delta)
	for child in children:
		child.rotation += delta * rotation_speed
