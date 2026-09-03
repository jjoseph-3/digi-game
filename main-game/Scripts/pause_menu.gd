extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func resume_pressed() -> void:
	queue_free()


func options_pressed() -> void:
	var new_scene = load("res://Scenes/options.tscn.tscn").instantiate()
	add_child(new_scene)


func quit_pressed() -> void:
	get_tree().quit()
