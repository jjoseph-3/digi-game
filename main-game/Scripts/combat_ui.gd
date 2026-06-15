extends Control

@export var current_rat_hp: ProgressBar
@export var enemy_rat_hp: ProgressBar
@export var player_spawn: Marker2D
@export var player_scene: PackedScene
@export var enemy_spawn: Marker2D
@export var enemy_scene: PackedScene

var attack_power: int = 5
var damage: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_rat_hp.max_value = Global.rat_hp
	current_rat_hp.value = current_rat_hp.max_value
	enemy_rat_hp.max_value = Global.wild_rat_hp
	enemy_rat_hp.value = enemy_rat_hp.max_value
	#change enemy_rat_hp to match the enemy rat script 
	
	var player_sprite = player_scene.instantiate()
	player_sprite.in_combat = true
	player_sprite.global_position = player_spawn.global_position
	add_child(player_sprite)
	
	var enemy_sprite = enemy_scene.instantiate()
	enemy_sprite.global_position = enemy_spawn.global_position
	add_child(enemy_sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _attack_1() -> void:
	damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack_power * (Global.rat_attack / Global.wild_rat_defence))))
	enemy_rat_hp.value = enemy_rat_hp.value - damage
	Global.wild_rat_hp = enemy_rat_hp.value
