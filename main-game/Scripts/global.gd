extends Node

const RAT_STATS = {
	"Johovian" : {
		"base_hp" : 50,
		"base_attack" : 50,
		"base_defence" : 60,
		"base_speed" : 20,
		"catch_rate" : 0.9,
		"base_yeild" : 60
	},
	"Wild Johovian" : {
		"base_hp" : 50,
		"base_attack" : 50,
		"base_defence" : 60,
		"base_speed" : 20,
		"catch_rate" : 0.9,
		"base_yeild" : 60
	},
	"Kartarian" : {
		"base_hp" : 50,
		"base_attack" : 20,
		"base_defence" : 80,
		"base_speed" : 30,
		"catch_rate" : 0.7,
		"base_yeild" : 90
	},
	"Wild Kartarian" : {
		"base_hp" : 50,
		"base_attack" : 20,
		"base_defence" : 80,
		"base_speed" : 30,
		"catch_rate" : 0.7,
		"base_yeild" : 60
	},
}

signal player_controllable
signal player_not_controllable

var rat_max_hp: float
var rat_hp: float
var rat_attack: float
var rat_defence: float
var rat_speed: float
var rat_level: float
var wild_rat_hp: float
var wild_rat_max_hp: float
var current_rat_max_hp_percent: float
var wild_rat_attack: float
var wild_rat_defence: float 
var wild_rat_speed: float
var wild_rat_level: float
var wild_rat_catch_rate: float
var base_yield: float
var party: Dictionary
var bag: Dictionary = {
	"Money": 120,
	"Rat net": 12,
	"Heal spray": 5
}
var item_buttons: Dictionary
var lead_rat: String
var enemy_type: String
var player: CharacterBody2D
var saved_position: Vector2 = Vector2.ZERO
var has_saved_position: bool = false


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Player"):
		player = node


func _process(delta: float) -> void:
	if not player == null:
		if player.lead_rat != lead_rat:
			player.lead_changed()


func reset():
	var script_path = Global.get_script().resource_path
	var autoload_script = load(script_path)
	Global.set_script(autoload_script)
	Global._ready()
