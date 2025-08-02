extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var game_over_label: Label = $GameOverLabel

func _ready():
	game_over_label.hide()

func update_score(score: int):
	score_label.text = "Score: " + str(score)

func show_game_over():
	game_over_label.text = "Game Over"
	game_over_label.show()
