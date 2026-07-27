extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.player_not_controllable.emit()


func _play_pressed() -> void:
	Player_auto.global_position = Vector2.ZERO
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")


func _options_opened() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/options.tscn")
