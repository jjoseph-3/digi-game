class_name Wild_rat
extends CharacterBody2D

const BASE_HP: float = 10
const BASE_STAT: float = 5
const LEVEL_SCALING: float = 0.01
const MIN_LEVEL: float = 3.0

var species = {
		"Johovian" :
		{
		"level" : 10,
		"current_hp" : 1
		},
		"Kartarian" :
		{
		"level" : 10,
		"current_hp" : 1
		},
	}
var rat_level

@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().name == "Combat":
		var keys = species.keys()
		var random_key = keys[randi_range(0, keys.size() - 1)]
		Global.enemy_type = random_key
		var base_stats = Global.RAT_STATS[random_key]
		var rat_data = species[random_key]
	
		rat_data["level"] = randi_range(max(1, Global.rat_level - MIN_LEVEL), Global.rat_level)
		#sets level based on player level
		
		Global.wild_rat_level = rat_data["level"]
		rat_level = rat_data["level"]
		Global.wild_rat_hp = int(floor(LEVEL_SCALING * (base_stats["base_hp"]) * rat_level)) + rat_level + BASE_HP 
		Global.wild_rat_max_hp = Global.rat_hp
		Global.wild_rat_attack = int(floor(LEVEL_SCALING * base_stats["base_attack"] * rat_level)) + BASE_STAT
		Global.wild_rat_defence = int(floor(LEVEL_SCALING * base_stats["base_defence"] * rat_level)) + BASE_STAT
		Global.wild_rat_speed = int(floor(LEVEL_SCALING * base_stats["base_speed"] * rat_level)) + BASE_STAT
		Global.wild_rat_catch_rate = base_stats["catch_rate"]
		Global.base_yield = base_stats["base_yeild"]
		rat_data["current_hp"] = Global.wild_rat_hp 
		
	if Global.enemy_type == "Johovian":
		var sprite = johovian_sprite_scene.instantiate()
		add_child(sprite)
		
	if Global.enemy_type == "Kartarian":
		var sprite = kartarian_sprite_scene.instantiate()
		add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().name == "Level":
		look_at(Player_auto.global_position)
		
	elif get_parent().name == "Combat":
		look_at(get_tree().current_scene.player_spawn.global_position)
	
func despawn_triggered() -> void:
	queue_free()
	
	
func encounter_started(body: Node2D) -> void:
	if body is Player:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/rat_screen.tscn")
		queue_free()
