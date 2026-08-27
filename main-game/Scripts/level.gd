class_name Level
extends Node2D

const SPAWN_CHANCE: float = 0.8

@export var wild_rat_spawn: PathFollow2D
@export var wild_rat_scene: PackedScene


func _ready() -> void:
	Global.player_controllable.emit()


func _process(delta: float) -> void:
	pass


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
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/shop.tscn")
