extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	Global.player_not_controllable.emit()


func play_pressed() -> void:
	Player_auto.global_position = Vector2.ZERO
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")


func options_opened() -> void:
	var new_scene = load("res://Scenes/options.tscn").instantiate()
	add_child(new_scene)


func quit_pressed() -> void:
	get_tree().quit()
