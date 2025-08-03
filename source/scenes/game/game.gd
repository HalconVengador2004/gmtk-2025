extends Node2D

@onready var task_manager: TaskManager = $TaskManager
@onready var hud = $HUD

func _ready():
	task_manager.score_updated.connect(hud.update_score)
	task_manager.game_lost.connect(hud.show_game_over)
