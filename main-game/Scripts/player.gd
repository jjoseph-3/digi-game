class_name Player
extends CharacterBody2D

const BASE_HP: float = 10
const BASE_STAT: float = 5
const LEVEL_SCALING: float = 0.01

var speed: float = 300.0
var in_tall_grass: bool = false
var lead_rat: String

@onready var player_sprite: AnimatedSprite2D = $Player_sprite
@onready var camera: Camera2D = $Camera2D

var party = {
		"Johovian" :
		{
		"level" : 1,
		"current_hp" : 30,
		"max_hp": 30,
		"exp" : 0
		},
		"Kartarian" :
		{
		"level" : 1,
		"current_hp" : 30,
		"max_hp": 30,
		"exp" : 0
		},
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_not_controllable.connect(player_not_controllable)
	Global.player_controllable.connect(player_controllable)
	
	Global.player = self
	print("player loaded")
	
	Global.party = party
	lead_rat = party.keys()[0]
	Global.lead_rat = lead_rat
	print(party.keys()[0])

	for rats in party:
		Global.rat_max_hp = int(floor(LEVEL_SCALING * Global.RAT_STATS[rats]["base_hp"]) * party[rats]["level"]) + party[rats]["level"] + BASE_HP
		Global.rat_hp = Global.rat_max_hp
		party[rats]["max_hp"] = Global.rat_max_hp
		party[rats]["current_hp"] = Global.rat_hp
		
	Global.rat_max_hp = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_hp"]) * party[lead_rat]["level"]) + party[lead_rat]["level"] + BASE_STAT
	Global.rat_hp = Global.rat_max_hp
	Global.rat_attack = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_attack"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_defence = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_defence"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_speed = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_speed"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_level = party[lead_rat]["level"]
	Global.base_yield = Global.RAT_STATS[lead_rat]["base_yeild"]
	#calculations for stats of each rat 
	
	print(Global.rat_hp)
	print(Global.rat_attack)
	print(Global.rat_defence)
	print(Global.rat_speed)
	print(Global.rat_level)
	print(party)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.ZERO
# Codes for my player movement 	
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
		player_sprite.flip_h = true
		player_sprite.animation = "run side"

	elif Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
		player_sprite.flip_h = false
		player_sprite.animation = "run side"
		
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
		player_sprite.animation = "run up"

	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
		player_sprite.animation = "run down"

	else: 
		player_sprite.animation = "idle"
# Ensures that the player can only move in one direction at a time		
	velocity = speed * direction.normalized()

	move_and_slide()
	
func lead_changed() -> void:
	print(Global.lead_rat)
	lead_rat = Global.lead_rat
	Global.rat_max_hp = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_hp"]) * party[lead_rat]["level"]) + party[lead_rat]["level"] + BASE_HP
	party[lead_rat]["max_hp"] = Global.rat_max_hp
	Global.rat_hp = party[lead_rat]["current_hp"]
	Global.rat_attack = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_attack"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_defence = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_defence"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_speed = int(floor(LEVEL_SCALING * Global.RAT_STATS[lead_rat]["base_speed"]) * party[lead_rat]["level"]) + BASE_STAT
	Global.rat_level = party[lead_rat]["level"]
	print(Global.rat_hp)
	print(Global.rat_attack)
	print(Global.rat_defence)
	print(Global.rat_speed)
	print(Global.rat_level)
	
func player_not_controllable():
	process_mode = Node.PROCESS_MODE_DISABLED
	camera.enabled = false
	player_sprite.hide()
	
func player_controllable():
	process_mode = Node.PROCESS_MODE_ALWAYS
	camera.enabled = true
	player_sprite.show()
	
func reset():
	var script_path = Player_auto.get_script().resource_path
	var autoload_script = load(script_path)
	Player_auto.set_script(autoload_script)
	Player_auto._ready()
