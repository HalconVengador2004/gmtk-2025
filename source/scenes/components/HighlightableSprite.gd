extends Sprite2D
class_name HighlightableSprite


@onready var highlighter = Highlightable.new()

func _ready():
	material = highlighter.setup(material)

func add_highlight():
	highlighter.add_highlight()

func remove_highlight():
	highlighter.remove_highlight()
