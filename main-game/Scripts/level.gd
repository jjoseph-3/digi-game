class_name Level
extends Node2D

const SPAWN_CHANCE: float = 0.7
const ANIMATION_SIDE: String = "run_side"
const ANIMATION_UP: String = "run_up"
const ANIMATION_DOWN: String = "run_down"
const ANIMATION_IDLE: String = "idle"

@export var wild_rat_spawn: PathFollow2D
@export var wild_rat_scene: PackedScene
@export var relative_positon: Node2D

@onready var player_sprite: AnimatedSprite2D = $Node2D/Player_sprite

func _ready() -> void:
	Global.player_controllable.emit()
	
	# Sets up the Node2D as players relative position for y-sorting 
	Global.relative_positon = relative_positon
	Player_auto.remote_distance_matcher.remote_path = \
	Player_auto.remote_distance_matcher.get_path_to(relative_positon)

func _process(delta: float) -> void:

# Codes for sprite animations on the player for y-sort
	if Player_auto.direction == Vector2.LEFT:
		player_sprite.flip_h = true
		player_sprite.animation = ANIMATION_SIDE
		
	elif Player_auto.direction == Vector2.RIGHT:
		player_sprite.flip_h = false
		player_sprite.animation = ANIMATION_SIDE
	
	elif Player_auto.direction == Vector2.UP:
		player_sprite.animation = ANIMATION_UP
		
	elif Player_auto.direction == Vector2.DOWN:
		player_sprite.animation = ANIMATION_DOWN
	
	else:
		player_sprite.animation = ANIMATION_IDLE
		

func tall_grass_entered(body: Node2D) -> void:
	if body is Player:
		if randf() < SPAWN_CHANCE: # Codes for an 80% encounter chance
			var wild_rat = wild_rat_scene.instantiate()
			wild_rat_spawn.progress_ratio = randf()
			wild_rat.global_position = wild_rat_spawn.global_position
			add_child(wild_rat) 
			# Spawns the wild rats 


func left_tall_grass(body: Node2D) -> void:
	if body is Player:
		for rat in get_tree().get_nodes_in_group("wild_rat"):
			rat.despawn_triggered()
			# Despawns the wild rats when player leaves area


func shop_opened(body: Node2D) -> void:
	if body is Player:
		Player_auto.global_position = Vector2.ZERO
		Player_auto.shop_opened()
