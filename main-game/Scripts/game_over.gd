extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	Global.player_not_controllable.emit()


func retry_pressed() -> void:
	Global.reset()
	Player_auto.reset()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Title.tscn")


func quit_pressed() -> void:
	get_tree().quit()
