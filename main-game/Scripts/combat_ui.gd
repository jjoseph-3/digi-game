extends Control

@export var current_rat_hp: ProgressBar

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_rat_hp.max_value = Global.rat1_hp
	print(current_rat_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
