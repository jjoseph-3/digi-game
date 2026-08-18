extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func resume_pressed() -> void:
	queue_free()


func options_pressed() -> void:
	pass


func quit_pressed() -> void:
	get_tree().quit()
