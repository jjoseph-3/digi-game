extends Control

@export var current_rat_hp: ProgressBar
@export var enemy_rat_hp: ProgressBar
@export var player_spawn: Marker2D
@export var player_scene: PackedScene
@export var enemy_spawn: Marker2D
@export var enemy_scene: PackedScene
@export var current_rat_level: Label
@export var enemy_rat_level: Label

var player_moved: bool = false
var enemy_moved: bool = false
var blocked: bool = false 
var attack1_power: float = 5
var attack2_power: float = 15
var attack3_power: float = 3
var damage: int  
var enemy_damage: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_rat_hp.max_value = Global.rat_hp
	current_rat_hp.value = current_rat_hp.max_value
	enemy_rat_hp.max_value = Global.wild_rat_hp
	enemy_rat_hp.value = enemy_rat_hp.max_value
	#change enemy_rat_hp to match the enemy rat script 
	print(current_rat_hp.max_value)
	print(enemy_rat_hp.max_value)
	
	enemy_rat_level.text = str("Level: ", Global.wild_rat_level)
	current_rat_level.text = str("Level: ", Global.rat_level)
	# Displays level of each rat 
	
	var player_sprite = player_scene.instantiate()
	player_sprite.in_combat = true
	player_sprite.global_position = player_spawn.global_position
	add_child(player_sprite)
	
	var enemy_sprite = enemy_scene.instantiate()
	enemy_sprite.global_position = enemy_spawn.global_position
	add_child(enemy_sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_rat_hp.value <= 0:
		print("enemy rat done")
		await get_tree().create_timer(1.0).timeout
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")
	
	if current_rat_hp.value <= 0:
		print("your rat is done")
		await get_tree().create_timer(1.0).timeout
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")
		
	if enemy_moved and player_moved == true:
		enemy_moved = false
		player_moved = false
		#allows both player and enemy to move again
		if blocked == true:
			Global.rat_defence = Global.rat_defence / 8
			blocked = false
			# resets defence of player rat 
	
	
func enemy_turn() -> void:
	if not enemy_rat_hp.value == 0:
		if Global.rat_hp <= current_rat_hp.max_value * 0.25:
			Global.wild_rat_speed = Global.wild_rat_speed * 2
			enemy_damage = int(floor((0.5 * (0.2 * (2 * Global.wild_rat_level)) + 2 * attack3_power * (Global.wild_rat_attack / Global.rat_defence))))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed * 0.5
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# if player hp is less than 1/4 of max enemy does a quick attack
			
		elif Global.wild_rat_hp <= enemy_rat_hp.max_value * 0.25:
			Global.wild_rat_speed = Global.wild_rat_speed * 2
			enemy_damage = int(floor((0.5 * (0.2 * (2 * Global.wild_rat_level)) + 2 * attack3_power * (Global.wild_rat_attack / Global.rat_defence))))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed * 0.5
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# if own hp is less than 1/4 of max enemy does a quick attack
			
		else:
		# random chance for "attack 1" or "attack 2" for enemy
			var enemy_attack = randi_range(0, 1)
			if enemy_attack == 0:
				enemy_damage = int(floor((0.5 * (0.2 * (2 * Global.wild_rat_level)) + 2 * attack1_power * (Global.wild_rat_attack / Global.rat_defence))))
				current_rat_hp.value = current_rat_hp.value - enemy_damage
				Global.rat_hp = current_rat_hp.value
				print("enemy did: ", enemy_damage, "damage")
				enemy_moved = true
			
			if enemy_attack == 1:
				var enemy_hit_chance: float = 0.75 
				if randf() < enemy_hit_chance:
					enemy_damage = int(floor((0.5 * (0.2 * (2 * Global.wild_rat_level)) + 2 * attack2_power * (Global.wild_rat_attack / Global.rat_defence))))
					current_rat_hp.value = current_rat_hp.value - enemy_damage
					Global.rat_hp = current_rat_hp.value
					print("enemy did: ", enemy_damage, "damage")
					enemy_moved = true
				


func _attack_1() -> void:
	if player_moved == false:
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(1.0).timeout
			damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack1_power * (Global.rat_attack / Global.wild_rat_defence))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			print("you did: ", damage, "damage")
			player_moved = true
		
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack1_power * (Global.rat_attack / Global.wild_rat_defence))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			print("you did: ", damage, "damage")
			player_moved = true
			await get_tree().create_timer(0.2).timeout
			enemy_turn()

func _attack_2() -> void:
	if player_moved == false:
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(1.0).timeout
			var hit_chance: float = 0.75 
			if randf() < hit_chance:
				damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack2_power * (Global.rat_attack / Global.wild_rat_defence))))
				enemy_rat_hp.value = enemy_rat_hp.value - damage
				Global.wild_rat_hp = enemy_rat_hp.value
				print("you did: ", damage, "damage")
			# 3x power but 75% hit chance 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			var hit_chance: float = 0.75 
			if randf() < hit_chance:
				damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack2_power * (Global.rat_attack / Global.wild_rat_defence))))
				enemy_rat_hp.value = enemy_rat_hp.value - damage
				Global.wild_rat_hp = enemy_rat_hp.value
				print("you did: ", damage, "damage")
				player_moved = true
				await get_tree().create_timer(1.0).timeout
				enemy_turn()

			else:
				print("you missed") 
				player_moved = true
				await get_tree().create_timer(1.0).timeout
				enemy_turn()
		# 3x power but 75% hit chance

func _attack_3() -> void:
	if player_moved == false:
		Global.rat_speed = Global.rat_speed * 2
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(1.0).timeout
			damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack3_power * (Global.rat_attack / Global.wild_rat_defence))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed * 0.5
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack3_power * (Global.rat_attack / Global.wild_rat_defence))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed * 0.5
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			await get_tree().create_timer(1.0).timeout
			enemy_turn()

func _block() -> void:
	if player_moved == false:
		Global.rat_speed = Global.rat_speed * 50
		Global.rat_defence = Global.rat_defence * 8
		Global.rat_speed = Global.rat_speed / 50
		print("you did: ", damage, "damage")
		blocked = true 
		player_moved = true 
		# defence increases 8x for one turn 
		await get_tree().create_timer(1.0).timeout
		enemy_turn()
	
	


func _bag_opened() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/bag.tscn")
