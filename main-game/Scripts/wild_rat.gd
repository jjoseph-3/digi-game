class_name WildRat
extends CharacterBody2D

const BASE_HP: float = 10
const BASE_STAT: float = 5
const LEVEL_SCALING: float = 0.01
const MIN_LEVEL: float = 3.0
const SPECIES_LEVEL: String = "level"
const SPECIES_CURRENT_HP: String = "current_hp"
const STATS_BASE_HP: String = "base_hp"
const STATS_BASE_ATTACK: String = "base_attack"
const STATS_BASE_DEFENCE: String = "base_defence"
const STATS_BASE_SPEED: String = "base_speed"
const STATS_CATCH_RATE: String = "catch_rate"
const STATS_BASE_YEILD: String = "base_yeild"
const JOHOVIAN_NAME: String = "Johovian"
const KARTARIAN_NAME: String = "Kartarian"

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

@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene: PackedScene


func _ready() -> void:
	if not get_parent().name == "Combat":
		var keys = species.keys()
		var random_key = keys[randi_range(0, keys.size() - 1)]
		Global.enemy_type = random_key
		var base_stats = Global.RAT_STATS[random_key]
		var rat_data = species[random_key]
	
		# Sets level based on player level
		rat_data[SPECIES_LEVEL] = randi_range(max(1, Global.rat_level - MIN_LEVEL)
		, Global.rat_level)
		
		# Calculations of stats
		Global.wild_rat_level = rat_data[SPECIES_LEVEL]
		var rat_level = rat_data[SPECIES_LEVEL]
		
		Global.wild_rat_hp = float(floor(LEVEL_SCALING * (base_stats[STATS_BASE_HP]) 
		* rat_level)) + rat_level + BASE_HP 
		Global.wild_rat_max_hp = Global.wild_rat_hp
		
		Global.wild_rat_attack = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_ATTACK] 
		* rat_level)) + BASE_STAT
		
		Global.wild_rat_defence = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_DEFENCE] 
		* rat_level)) + BASE_STAT
		
		Global.wild_rat_speed = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_SPEED] 
		* rat_level)) + BASE_STAT
		
		Global.wild_rat_catch_rate = base_stats[STATS_CATCH_RATE]
		print("catch chance: ", Global.wild_rat_catch_rate)
		
		Global.base_yield = base_stats[STATS_BASE_YEILD]
		
		rat_data[SPECIES_CURRENT_HP] = Global.wild_rat_hp 
		
	# Adds sprites depending on what 'species' is being spawned
	if Global.enemy_type == JOHOVIAN_NAME:
		Global.enemy_sprite = johovian_sprite_scene.instantiate()
		add_child(Global.enemy_sprite)
		
	if Global.enemy_type == KARTARIAN_NAME:
		Global.enemy_sprite = kartarian_sprite_scene.instantiate()
		add_child(Global.enemy_sprite)


func _process(delta: float) -> void:
	# Allows the rat to look around depending on the scene its in
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
