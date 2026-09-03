extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func quit_pressed() -> void:
		get_tree().quit()


func play_pressed() -> void:
	Player_auto.global_position = Vector2.ZERO
	Global.reset()
	Player_auto.reset()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")
