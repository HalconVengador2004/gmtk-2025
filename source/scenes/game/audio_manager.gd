extends Node

@export var music_player: AudioStreamPlayer
var intensity_state : String
var sfx_library = {
	"workerassign":preload("res://assets/audio/sfx/Worker/sfx_WorkerAssign_2-001.ogg"),
	"workercomplete":preload("res://assets/audio/sfx/Worker/sfx_WorkerComplete_1.ogg"),
	"workerselect":preload("res://assets/audio/sfx/Worker/sfx_WorkerSelect_3.ogg"),
	"workerwork":preload("res://assets/audio/sfx/Worker/sfx_WorkerWork.ogg"),
	"problemalert":preload("res://assets/audio/sfx/Problem/sfx_ProblemAlert.ogg"),
	"problembroken":preload("res://assets/audio/sfx/Problem/sfx_ProblemBroken_2.ogg"),
	"problemstart":preload("res://assets/audio/sfx/Problem/sfx_ProblemStart_3-001.ogg"),
	"uiconfirm":preload("res://assets/audio/sfx/UI/sfx_UIConfirm.ogg"),
	"uiselect":preload("res://assets/audio/sfx/UI/sfx_UIselect_1.ogg"),
	"uideselect":preload("res://assets/audio/sfx/UI/sfx_UIdeselect_3.ogg")
}
sfx_library[SfxPlayer]
@onready var music_library = $MusicPlayer

func _ready():
	$MusicPlayer.play()
	SignalBus.eventName.Conetct(functionName)
	
func _physics_process(_delta):
	var new_sfx_player = $SfxPlayer.duplicate()
	new_sfx_player.stream = sfx_library
	add_child(new_sfx_player)
	new_sfx_player.play()
	new_sfx_player.finished.connect(_on_sfx_finished)
	
func _on_sfx_finished(node_to_free):
	node_to_free.queue_free()
	
	
