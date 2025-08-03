extends Node

@export var worker_assign_sounds: Array[AudioStream]
@export var worker_complete_sounds: Array[AudioStream]
@export var worker_select_sounds: Array[AudioStream]
@export var worker_work_sound: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#func _ready() -> void:
	#play_worker_work_sound()


func play_worker_assign_sound():
	audio_stream_player.stream = get_random_audio_stream(worker_assign_sounds)
	audio_stream_player.play()
func play_worker_complete_sound():
	audio_stream_player.stream = get_random_audio_stream(worker_complete_sounds)
	audio_stream_player.play()
func play_worker_select_sound():
	audio_stream_player.stream = get_random_audio_stream(worker_select_sounds)
	audio_stream_player.play()
func play_worker_work_sound():
	if audio_stream_player.playing:
		return
	audio_stream_player.stream = worker_work_sound
	audio_stream_player.play()
func stop_worker_work_sound():
	audio_stream_player.stop()
	audio_stream_player.stream = null

func get_random_audio_stream(streams: Array[AudioStream]) -> AudioStream:
	if streams.is_empty():
		return null
	var random_index = randi() % streams.size()
	return streams[random_index]
