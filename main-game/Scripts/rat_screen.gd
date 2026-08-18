extends Control

@export var party_rat_scene: PackedScene
@export var party_rat_spawn: VBoxContainer
@export var vbox: VBoxContainer


func _ready() -> void:
	# Spawns buttons for the player to choose what rat they want to battle with
	for rat in Global.party:
		var party_rat_button = party_rat_scene.instantiate()
		party_rat_button.text = rat
		party_rat_button.global_position = party_rat_spawn.global_position
		vbox.add_child(party_rat_button)


func _process(delta: float) -> void:
	Global.player_not_controllable.emit()
