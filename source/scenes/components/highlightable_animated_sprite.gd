extends AnimatedSprite2D
class_name HighlightableAnimatedSprite

@onready var highlighter = Highlightable.new()

func _ready():
	material = highlighter.setup(material)

func add_highlight():
	highlighter.add_highlight()

func remove_highlight():
	highlighter.remove_highlight()

func play_animation(anim: String):
	play(anim)
