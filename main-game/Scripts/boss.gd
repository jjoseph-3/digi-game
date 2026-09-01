extends CharacterBody2D

const FINAL_BOSS_STATS: Dictionary = {
	"The one" : {
		"base_hp" : 80,
		"base_attack" : 70,
		"base_defence" : 80,
		"base_speed" : 60,
		"catch_rate" : "not_catchable",
		"base_yeild" : 100
		}
}
const FIRST_KEY: String = "The one"
const SPECIES_LEVEL: String = "level"
const SPECIES_CURRENT_HP: String = "current_hp"
const STATS_BASE_HP: String = "base_hp"
const STATS_BASE_ATTACK: String = "base_attack"
const STATS_BASE_DEFENCE: String = "base_defence"
const STATS_BASE_SPEED: String = "base_speed"
const STATS_CATCH_RATE: String = "catch_rate"
const STATS_BASE_YEILD: String = "base_yeild"
const LEVEL_SCALING: float = 0.01
const BASE_HP: float = 10
const BASE_STAT: float = 5
const RAT_LEVEL: float = 30.0

var boss_stats: Dictionary = {
	"The one": {
		
	}
}

@export var boss_scene: PackedScene


func _ready() -> void:
	var rat_data = boss_stats[FIRST_KEY]
	var base_stats = FINAL_BOSS_STATS[FIRST_KEY]
	
	# Calculations of stats
	Global.wild_rat_level = RAT_LEVEL
	
	Global.wild_rat_hp = float(floor(LEVEL_SCALING * (base_stats[STATS_BASE_HP]) 
	* RAT_LEVEL)) + RAT_LEVEL + BASE_HP
	Global.wild_rat_max_hp = Global.wild_rat_hp
	
	Global.wild_rat_attack = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_ATTACK] 
	* RAT_LEVEL)) + BASE_STAT
	
	Global.wild_rat_defence = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_DEFENCE] 
	* RAT_LEVEL)) + BASE_STAT
	
	Global.wild_rat_speed = float(floor(LEVEL_SCALING * base_stats[STATS_BASE_SPEED] 
	* RAT_LEVEL)) + BASE_STAT
	
	Global.wild_rat_catch_rate = base_stats[STATS_CATCH_RATE]
	print("catch chance: ", Global.wild_rat_catch_rate)
	
	Global.base_yield = base_stats[STATS_BASE_YEILD]

	Global.enemy_type = FIRST_KEY


func _process(delta: float) -> void:
	pass


func boss_challenged(body: Node2D) -> void:
	if body is Player:
		Global.boss_active = true
		print("boss active")
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/rat_screen.tscn")
		queue_free()
