extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("splash_screen_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "splash_screen_animation":
		SceneManager.change_scene("res://source/scenes/ui/main_menu.tscn")
