class_name Player
extends CharacterBody2D

const BASE_HP: float = 10
const BASE_STAT: float = 5
const LEVEL_SCALING: float = 0.01
const PARTY_BASE: Dictionary = {
	"Johovian" :
	{
		"level" : 1,
		"current_hp" : 0,
		"max_hp": 0,
		"exp" : 0
	},
	"Kartarian" :
	{
		"level" : 1,
		"current_hp" : 0,
		"max_hp": 0,
		"exp" : 0
	},
}
const PARTY_LEVEL: String = "level"
const PARTY_MAX_HP: String = "max_hp"
const PARTY_CURRENT_HP: String = "current_hp"
const STATS_BASE_HP: String = "base_hp"
const STATS_BASE_ATTACK: String = "base_attack"
const STATS_BASE_DEFENCE: String = "base_defence"
const STATS_BASE_SPEED: String = "base_speed"
const STATS_BASE_YEILD: String = "base_yeild"
const ANIMATION_SIDE: String = "run_side"
const ANIMATION_UP: String = "run_up"
const ANIMATION_DOWN: String = "run_down"
const ANIMATION_IDLE: String = "idle"

var direction: Vector2
var speed: float = 300.0
var in_tall_grass: bool = false
var lead_rat: String
var party: Dictionary

@export var new_scene_spawn: Camera2D
@export var remote_distance_matcher: RemoteTransform2D

@onready var player_sprite: AnimatedSprite2D = $Player_sprite
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	if Global.has_saved_position:
		global_position = Global.saved_position
		Global.has_saved_position = false 
		
	# Fix to a bug where declaring a dict with a const makes it read only
	party = PARTY_BASE.duplicate_deep() 
	Global.party = party
	lead_rat = party.keys()[0]
	Global.lead_rat = lead_rat
	print(party.keys()[0])
	
	Global.player_not_controllable.connect(player_not_controllable)
	Global.player_controllable.connect(player_controllable)

	Global.player = self
	print("player loaded")

	# Puts the max and current hps into the party dictionary
	for rats in party:
		Global.rat_max_hp = float(floor(LEVEL_SCALING * Global.RAT_STATS[rats][STATS_BASE_HP]) 
		* party[rats][PARTY_LEVEL]) + party[rats][PARTY_LEVEL] + BASE_HP
		Global.rat_hp = Global.rat_max_hp
		party[rats][PARTY_MAX_HP] = Global.rat_max_hp
		party[rats][PARTY_CURRENT_HP] = Global.rat_hp
		
	# Stat calculations for the players rat
	Global.rat_max_hp = float(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat][STATS_BASE_HP]) 
	* party[lead_rat][PARTY_LEVEL]) + party[lead_rat][PARTY_LEVEL] + BASE_HP
	Global.rat_hp = Global.rat_max_hp
	
	Global.rat_attack = float(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat][STATS_BASE_ATTACK]) 
	* party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_defence = float(floor(LEVEL_SCALING 
	* Global.RAT_STATS[lead_rat][STATS_BASE_DEFENCE]) * party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_speed = float(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat][STATS_BASE_SPEED]) 
	* party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_level = party[lead_rat][PARTY_LEVEL]
	
	Global.base_yield = Global.RAT_STATS[lead_rat][STATS_BASE_YEILD]
	
	print(Global.rat_hp)
	print(Global.rat_attack)
	print(Global.rat_defence)
	print(Global.rat_speed)
	print(Global.rat_level)
	print(party)
	

func _process(delta: float) -> void:
	direction = Vector2.ZERO
	
# Codes for my player movement 	
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT

	elif Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
		
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
		
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN

# Ensures that the player can only move in one direction at a time
	velocity = speed * direction.normalized()

	move_and_slide()


func lead_changed(called_from_combat: bool = false) -> void:
	print(Global.lead_rat)
	lead_rat = Global.lead_rat
	
	party[lead_rat][PARTY_MAX_HP] = float(floor(LEVEL_SCALING
	* Global.RAT_STATS[lead_rat][STATS_BASE_HP]) 
	* party[lead_rat][PARTY_LEVEL]) + party[lead_rat][PARTY_LEVEL] + BASE_HP
	
	# Keeps the rats hp between battles
	if called_from_combat:
		print("called from combat")
		party[lead_rat][PARTY_CURRENT_HP] = party[lead_rat][PARTY_MAX_HP] \
		if Global.current_rat_max_hp_percent \
		== 0 else roundf(Global.current_rat_max_hp_percent * party[lead_rat][PARTY_MAX_HP])
		
	else: 
		party[lead_rat][PARTY_CURRENT_HP] = party[lead_rat][PARTY_CURRENT_HP]
		
	Global.rat_attack = float(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat][STATS_BASE_ATTACK]) 
	* party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_defence = float(floor(LEVEL_SCALING 
	* Global.RAT_STATS[lead_rat][STATS_BASE_DEFENCE]) * party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_speed = float(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat][STATS_BASE_SPEED]) 
	* party[lead_rat][PARTY_LEVEL]) + BASE_STAT
	
	Global.rat_level = party[lead_rat][PARTY_LEVEL]
	
	print(Global.rat_hp)
	print(Global.rat_attack)
	print(Global.rat_defence)
	print(Global.rat_speed)
	print(Global.rat_level)
	print(party)


func player_not_controllable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	camera.enabled = false


func player_controllable() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	camera.enabled = true
	remote_distance_matcher.remote_path = \
	remote_distance_matcher.get_path_to(Global.relative_positon)


func reset() -> void:
	var script_path = Player_auto.get_script().resource_path
	var autoload_script = load(script_path)
	Player_auto.set_script(autoload_script)
	Player_auto._ready()


func save_position() -> void:
	Global.saved_position = global_position
	Global.has_saved_position = true


func bag_opened() -> void:
	save_position()
	var new_scene = load("res://Scenes/bag.tscn").instantiate()
	var level = get_tree().get_first_node_in_group("Level")
	level.add_child(new_scene)

func shop_opened() -> void:
	var new_scene = load("res://Scenes/shop.tscn").instantiate()
	var level = get_tree().get_first_node_in_group("Level")
	level.add_child(new_scene)
