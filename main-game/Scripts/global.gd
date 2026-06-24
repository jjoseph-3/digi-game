extends Node

var rat_hp: float
var rat_attack: float
var rat_defence: float
var rat_speed: float
var rat_level: float
var wild_rat_hp: float
var wild_rat_attack: float
var wild_rat_defence: float 
var wild_rat_speed: float
var wild_rat_level: float
var party: Dictionary
var bag: Dictionary
var lead_rat: String
var enemy_type: String
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Player"):
		player = node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player == null:
		if player.lead_rat != lead_rat:
			player.lead_changed()
