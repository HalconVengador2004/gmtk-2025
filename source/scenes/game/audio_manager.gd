extends Node

@export var music_player: AudioStreamPlayer
var intensity_state : String
var sfx_library = {
	"workerassign":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_2jurd"),
	"workercomplete":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_b0not"),
	"workerselect":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_b7cst"),
	"workerwork":preload("res://assets/audio/sfx/Worker/sfx_WorkerWork.ogg"),
	"problemalert":preload("res://assets/audio/sfx/Problem/sfx_ProblemAlert.ogg"),
	"problembroken":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_vrq42"),
	"problemstart":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_ftnvo"),
	"uiconfirm":preload("res://assets/audio/sfx/UI/sfx_UIConfirm.ogg"),
	"uiselect":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_j74dg"),
	"uideselect":preload("res://source/scenes/game/game.tscn::AudioStreamRandomizer_e1c0h")
	}


func createVfx(name):
	var new_sfx_player = $SfxPlayer.duplicate()
	new_sfx_player.stream = sfx_library
	add_child(new_sfx_player)
	new_sfx_player.play()
	new_sfx_player.finished.connect(_on_sfx_finished)


func on_working_start():
	createVfx("workerwork")

func _on_interactable_clicked():
	createVfx("workerassign")

func select_worker():
	createVfx("workerselect")
	
func _on_task_completed():
	createVfx("workercomplete")

func _on_task_started():
	createVfx("problemstart")


@onready var music_library = $MusicPlayer

func _ready():
	$MusicPlayer.play()
	SignalBus.eventName.Conetct(functionName)
	
	
	
	
func _on_sfx_finished(node_to_free):
	node_to_free.queue_free()
	
	
