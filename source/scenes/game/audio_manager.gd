extends Node

@export var music_player: AudioStreamPlayer
@onready var music_library = $MusicPlayer
@onready var sfx_template = $SfxPlayer

func _ready():
	SignalBus.task_work_started.connect(on_working_start)
	SignalBus.other_selected.connect(_on_interactable_clicked)
	SignalBus.work_selected.connect(_select_worker)
	SignalBus.task_completed.connect(_on_task_completed)
	SignalBus.task_activated.connect(_on_task_started)

var sfx_library: Dictionary = {
	"workerassign":preload("res://assets/audio/sfx/Worker/sfx_WorkerAssign_2-001.ogg"),
	"workercomplete":preload("res://assets/audio/sfx/Worker/sfx_WorkerComplete_1.ogg"),
	"workerselect":preload("res://assets/audio/sfx/Worker/sfx_WorkerSelect_1.ogg"),
	"workerwork":preload("res://assets/audio/sfx/Worker/sfx_WorkerWork.ogg"),
	"problemalert":preload("res://assets/audio/sfx/Problem/sfx_ProblemAlert.ogg"),
	"problembroken":preload("res://assets/audio/sfx/Problem/sfx_ProblemBroken_2.ogg"),
	"problemstart":preload("res://assets/audio/sfx/Problem/sfx_ProblemStart_3-001.ogg"),
	"uiconfirm":preload("res://assets/audio/sfx/UI/sfx_UIConfirm.ogg"),
	"uiselect":preload("res://assets/audio/sfx/UI/sfx_UIselect_1.ogg"),
	"uideselect":preload("res://assets/audio/sfx/UI/sfx_UIdeselect_1.ogg")
	}

func createVfx(key):
	return # remove this later
	var new_sfx_player = sfx_template.duplicate()
	new_sfx_player.stream = sfx_library[key]
	add_child(new_sfx_player)
	new_sfx_player.play()
	new_sfx_player.finished.connect(_on_sfx_finished, new_sfx_player)


func on_working_start(_task_instance):
	createVfx("workerwork")

func _on_interactable_clicked(_node):
	createVfx("workerassign")

func _select_worker(_worker):
	createVfx("workerselect")
	
func _on_task_completed(_task):
	createVfx("workercomplete")

func _on_task_started(_task):
	createVfx("problemstart")

func _on_sfx_finished(node_to_free):
	node_to_free.queue_free()
