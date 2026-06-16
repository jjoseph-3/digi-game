class_name Wild_rat
extends CharacterBody2D

@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene: PackedScene

const RAT_STATS = {
	"Johovian": {
		"base_hp": 50,
		"base_attack": 50,
		"base_defence": 60,
		"base_speed": 20
	},
	"Kartarian": {
		"base_hp": 50,
		"base_attack": 20,
		"base_defence": 80,
		"base_speed": 50
	},
}

var species = {
		"Johovian" :
		{
		"level": 5,
		"current_hp": 1
		},
		"Kartarian" :
		{
		"level": 5,
		"current_hp": 1
		},
	}

var rat_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var keys = species.keys()
	var random_key = keys[randi_range(0, keys.size() - 1)]
	var base_stats = RAT_STATS[random_key]
	var rat_data = species[random_key]
	
	Global.wild_rat_level = rat_data["level"]
	rat_level = rat_data["level"]
	Global.wild_rat_hp = int(floor(0.01 * (2 * base_stats["base_hp"]) * rat_level)) + rat_level + 10 
	Global.wild_rat_attack = int(floor(0.01 * 2 * base_stats["base_attack"] * rat_level)) + 5
	Global.wild_rat_defence = int(floor(0.01 * 2 * base_stats["base_defence"] * rat_level)) + 5
	Global.wild_rat_speed = int(floor(0.01 * 2 * base_stats["base_speed"] * rat_level)) + 5
	rat_data["current_hp"] = Global.wild_rat_hp 
	
	if random_key == "Johovian":
		var sprite = johovian_sprite_scene.instantiate()
		add_child(sprite)
		
	elif random_key == "Kartarian":
		var sprite = kartarian_sprite_scene.instantiate()
		add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func despawn() -> void:
	queue_free()
	
	
func _encounter_start(body: Node2D) -> void:
	if body is Player:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/combat_ui.tscn")
