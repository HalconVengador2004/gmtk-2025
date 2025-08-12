# Bed.gd
extends SmartObject
class_name Bed

var is_occupied_by: Worker = null
@onready var anim_sprite: AnimatedSprite2D = $HighlightableSprite

func _ready():
	super()
	SignalBus.connect("worker_sleeping", _on_worker_sleeping)
	SignalBus.connect("worker_stopped_sleeping", _on_worker_stopped_sleeping)
	anim_sprite.play('default');

func occupy(worker: Worker) -> void:
	is_occupied_by = worker

func release() -> void:
	is_occupied_by = null
	anim_sprite.play('default');

func _on_worker_sleeping(bed: Bed):
	if is_occupied_by and bed == self:
		anim_sprite.play('sleeping');
		

func _on_worker_stopped_sleeping(bed: Bed):
	if is_occupied_by and bed == self:
		anim_sprite.play('default');

