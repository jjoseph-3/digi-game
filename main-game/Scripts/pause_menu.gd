extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func resume_pressed() -> void:
	queue_free()


func options_pressed() -> void:
	pass # Replace with function body.


func quit_pressed() -> void:
	get_tree().quit()
