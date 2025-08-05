extends Node2D

@onready var task_manager: TaskManager = $TaskManager
@onready var hud = $HUD
@onready var worker_manager = $WorkerManager

const WORKER_SCENE = preload("res://source/scenes/worker/worker.tscn")

func _ready():
	task_manager.score_updated.connect(hud.update_score)
	task_manager.stop_countdown.connect(hud.stop_countdown)
	task_manager.start_countdown.connect(hud.start_countdown)
	SignalBus.day_changed.connect(on_day_changed)

func on_day_changed(day: int):
	print(day)
	if day == 3:
		var worker: Worker = WORKER_SCENE.instantiate()
		worker.position = Vector2(18.0, 612.0)
		worker_manager.add_child(worker)
		worker.move_to_position(Vector2(286, 612))
	if day == 5:
		var worker = WORKER_SCENE.instantiate()
		worker.position = Vector2(18.0, 612.0)
		worker_manager.add_child(worker)
		worker.move_to_position(Vector2(286, 612))
