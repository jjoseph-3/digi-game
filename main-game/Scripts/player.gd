class_name Player
extends CharacterBody2D

#store rats in dictionary 
var speed: float = 300.0
var in_tall_grass: bool = false

const RAT_STATS = {
	"type1": {
		"base_hp": 50,
		"base_attack": 50,
		"base_defence": 50
	},
}

var party = {
		"type1" :
		{
		"level": 10,
		"current_hp": 11
		}
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for rats in party:
		Global.rat_hp = int(floor(0.01 * (2 * RAT_STATS[rats]["base_hp"]) * party[rats]["level"])) + party[rats]["level"] + 10
		Global.rat_attack = int(floor(0.01 * 2 * RAT_STATS[rats]["base_attack"] * party[rats]["level"])) + 5
		Global.rat_defence = int(floor(0.01 * 2 * RAT_STATS[rats]["base_defence"] * party[rats]["level"])) + 5
		Global.rat_level = party[rats]["level"]
	#calculations for stats of each rat 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.ZERO
# Codes for my player movement 	
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
# Ensures that the player can only move in one direction at a time		
	velocity = speed * direction.normalized()

	move_and_slide()
	
	
	
