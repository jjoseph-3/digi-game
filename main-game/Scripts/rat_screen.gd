extends Control

@export var party_rat_scene: PackedScene
@export var party_rat_spawn: VBoxContainer
@export var vbox: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for rat in Global.party:
		var party_rat = party_rat_scene.instantiate()
		party_rat.text = rat
		party_rat.global_position = party_rat_spawn.global_position
		vbox.add_child(party_rat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.player_not_controllable.emit()
