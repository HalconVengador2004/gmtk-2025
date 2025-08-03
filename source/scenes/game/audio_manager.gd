extends Node

@export var music_player: AudioStreamPlayer
var intensity_state : String
@onready var sfx_library = $SfxPlayer
@onready var music_library = $MusicPlayer

func _ready():
	$MusicPlayer.play()
	
func _physics_process(_delta):
	var new_sfx_player = $SfxPlayer.duplicate()
	new_sfx_player.stream = sfx_library[]
	add_child(new_sfx_player)
	new_sfx_player.play()
	new_sfx_player.finished.connect(_on_sfx_finished)
	
func _on_sfx_finished(node_to_free):
	node_to_free.queue_free()
	
	
