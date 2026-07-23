class_name Player
extends CharacterBody2D

@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene:PackedScene

var speed: float = 300.0
var in_tall_grass: bool = false
var in_combat: bool = false
var lead_rat: String

var party = {
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player = self
	if not get_parent().name == "Combat":
		Global.party = party
		#transports the party list into Global
		
		lead_rat = party.keys()[0]
		Global.lead_rat = lead_rat
		print(party.keys()[0])
		Global.lead_rat = lead_rat
		Global.rat_hp = int(floor(0.01 * (2 * Global.RAT_STATS[lead_rat]["base_hp"]) * party[lead_rat]["level"])) + party[lead_rat]["level"] + 10
		party[lead_rat]["current_hp"] = Global.rat_hp
		Global.rat_attack = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_attack"] * party[lead_rat]["level"])) + 5
		Global.rat_defence = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_defence"] * party[lead_rat]["level"])) + 5
		Global.rat_speed = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_speed"] * party[lead_rat]["level"])) + 5
		Global.rat_level = party[lead_rat]["level"]
		#calculations for stats of each rat 
		
		print(Global.rat_hp)
		print(Global.rat_attack)
		print(Global.rat_defence)
		print(Global.rat_speed)
		print(Global.rat_level)
		
	if get_parent().name == "Combat":
		$Player_sprite.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not in_combat:
		var direction = Vector2.ZERO
	# Codes for my player movement 	
		if Input.is_action_pressed("ui_left"):
			direction = Vector2.LEFT
			$Player_sprite.flip_h = true
			$Player_sprite.animation = "run side"

		elif Input.is_action_pressed("ui_right"):
			direction = Vector2.RIGHT
			$Player_sprite.flip_h = false
			$Player_sprite.animation = "run side"
			
		elif Input.is_action_pressed("ui_up"):
			direction = Vector2.UP
			$Player_sprite.animation = "run up"

		elif Input.is_action_pressed("ui_down"):
			direction = Vector2.DOWN
			$Player_sprite.animation = "run down"

		else: 
			$Player_sprite.animation = "idle"
	# Ensures that the player can only move in one direction at a time		
		velocity = speed * direction.normalized()

		move_and_slide()
	
	
func lead_changed() -> void:
	print(Global.lead_rat)
	lead_rat = Global.lead_rat
	Global.rat_hp = int(floor(0.01 * (2 * Global.RAT_STATS[lead_rat]["base_hp"]) * party[lead_rat]["level"])) + party[lead_rat]["level"] + 10
	party[lead_rat]["current_hp"] = Global.rat_hp
	Global.rat_attack = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_attack"] * party[lead_rat]["level"])) + 5
	Global.rat_defence = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_defence"] * party[lead_rat]["level"])) + 5
	Global.rat_speed = int(floor(0.01 * 2 * Global.RAT_STATS[lead_rat]["base_speed"] * party[lead_rat]["level"])) + 5
	Global.rat_level = party[lead_rat]["level"]
	print(Global.rat_hp)
	print(Global.rat_attack)
	print(Global.rat_defence)
	print(Global.rat_speed)
	print(Global.rat_level)
	
	if lead_rat == "Johovian":
		var sprite = johovian_sprite_scene.instantiate()
		add_child(sprite)
		
	if lead_rat == "Kartarian":
		var sprite = kartarian_sprite_scene.instantiate()
		add_child(sprite)
		
		
func rat_caught() -> void:
	print("rat caught")
	
