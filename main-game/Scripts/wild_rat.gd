class_name Wild_rat
extends CharacterBody2D

@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene: PackedScene

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().name == "Combat":
		var keys = species.keys()
		var random_key = keys[randi_range(0, keys.size() - 1)]
		Global.enemy_type = random_key
		var base_stats = Global.RAT_STATS[random_key]
		var rat_data = species[random_key]
	
		rat_data["level"] = randi_range(max(1, Global.rat_level - 3), Global.rat_level)
		#sets level based on player level
		
		Global.wild_rat_level = rat_data["level"]
		rat_level = rat_data["level"]
		Global.wild_rat_hp = int(floor(0.01 * (2 * base_stats["base_hp"]) * rat_level)) + rat_level + 10 
		Global.wild_rat_attack = int(floor(0.01 * 2 * base_stats["base_attack"] * rat_level)) + 5
		Global.wild_rat_defence = int(floor(0.01 * 2 * base_stats["base_defence"] * rat_level)) + 5
		Global.wild_rat_speed = int(floor(0.01 * 2 * base_stats["base_speed"] * rat_level)) + 5
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
	pass

func despawn() -> void:
	queue_free()
	
	
func _encounter_start(body: Node2D) -> void:
	if body is Player:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/rat_screen.tscn")
		queue_free()
