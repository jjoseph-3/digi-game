extends Button


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func rat_selected() -> void:
	Global.lead_rat = text
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/combat_ui.tscn")
