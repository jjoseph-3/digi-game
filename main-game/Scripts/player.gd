class_name Player
extends CharacterBody2D

var rat1_level: int = 1
var rat1_attack: int = 1
#store rats in dictionary 
var speed: float = 300.0
var in_tall_grass: bool = false
var base_hp: int = 50
var base_attack: int = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.rat1_hp = int(floor(0.01 * (2 * base_hp) * rat1_level)) + rat1_level + 10 
	rat1_attack = int(floor(0.01 * 2 * base_attack * rat1_level)) + 5
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
	
	
	
