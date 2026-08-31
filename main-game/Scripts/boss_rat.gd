extends AnimatedSprite2D


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if get_parent().name == "Combat":
		look_at(get_tree().current_scene.player_spawn.global_position)
