extends Control

@export var current_rat_hp: ProgressBar
@export var enemy_rat_hp: ProgressBar
@export var player_spawn: Marker2D
@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene:PackedScene
@export var enemy_spawn: Marker2D
@export var enemy_scene: PackedScene
@export var current_rat_level: Label
@export var enemy_rat_level: Label

const LOW_HP_THRESHOLD: float = 0.25
const SPEED_MULTI: float = 2
const BLOCK_SPEED_MULTI: float = 50
const ENEMY_HIT_CHANCE: float = 0.75
const DEFENCE_MULTIPLIER: float = 8
const DAMAGE_SCALING: float = 0.2

var player_moved: bool = false
var enemy_moved: bool = false
var blocked: bool = false 
var enemy_alive: bool = true 
var player_alive: bool = true 
var attack1_power: float = 5
var attack2_power: float = 15
var attack3_power: float = 3
var damage: int  
var enemy_damage: int
var catch_chance: float
var player: CharacterBody2D
var new_rat: String
var trainer_bonus: float = 1
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_rat_hp.max_value = Global.rat_max_hp
	current_rat_hp.value = Global.rat_hp
	enemy_rat_hp.max_value = Global.wild_rat_hp
	enemy_rat_hp.value = enemy_rat_hp.max_value
	#change enemy_rat_hp to match the enemy rat script 
	print(current_rat_hp.max_value)
	print(enemy_rat_hp.max_value)
	
	enemy_rat_level.text = str("Level: ", Global.wild_rat_level)
	current_rat_level.text = str("Level: ", Global.rat_level)
	# Displays level of each rat 
	
	if Global.lead_rat == "Johovian":
		var player_sprite = johovian_sprite_scene.instantiate()
		player_sprite.scale = Vector2(5, 5)
		player_sprite.global_position = player_spawn.global_position
		add_child(player_sprite)
		
	elif Global.lead_rat == "Kartarian":
		var player_sprite = kartarian_sprite_scene.instantiate()
		player_sprite.scale = Vector2(5, 5)
		player_sprite.global_position = player_spawn.global_position
		add_child(player_sprite)
	
	var enemy_sprite = enemy_scene.instantiate()
	enemy_sprite.scale = Vector2(8, 8)
	enemy_sprite.global_position = enemy_spawn.global_position
	add_child(enemy_sprite)
	#spawns enemy and player sprites
	
	new_rat = "Wild " + str(Global.enemy_type)
	#sets the name of the new rat (if caught)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.player_not_controllable.emit()
	
	
	if enemy_moved or player_moved == true:
		if enemy_rat_hp.value <= 0:
			enemy_alive = false
		
		elif current_rat_hp.value <= 0:
			player_dead()
			
		if enemy_alive == false:
			enemy_dead()
			enemy_alive = true
			
		elif player_alive == false:
			player_dead()
			player_alive = true
	
	if enemy_moved and player_moved == true:
		enemy_moved = false
		player_moved = false
		#allows both player and enemy to move again
		if blocked == true:
			Global.rat_defence = Global.rat_defence / DEFENCE_MULTIPLIER
			blocked = false
			# resets defence of player rat 
	
	
func enemy_turn() -> void:
	if not enemy_rat_hp.value <= 0:
		if Global.rat_hp <= current_rat_hp.max_value * LOW_HP_THRESHOLD:
			Global.wild_rat_speed = Global.wild_rat_speed * SPEED_MULTI
			enemy_damage = int(floor(((DAMAGE_SCALING * Global.wild_rat_level) + 2) * attack3_power * 0.02 * (Global.wild_rat_attack / Global.rat_defence)))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed / SPEED_MULTI
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# if player hp is less than 1/4 of max enemy does a quick attack
			
		elif Global.wild_rat_hp <= enemy_rat_hp.max_value * LOW_HP_THRESHOLD:
			Global.wild_rat_speed = Global.wild_rat_speed * SPEED_MULTI
			enemy_damage = int(floor(((DAMAGE_SCALING * Global.wild_rat_level) + 2) * attack3_power * 0.02 * (Global.wild_rat_attack / Global.rat_defence)))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed / SPEED_MULTI
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# if own hp is less than 1/4 of max enemy does a quick attack
			
		else:
		# random chance for "normal attack" or "power attack" for enemy
			var enemy_attack = randi_range(0, 1)
			if enemy_attack == 0:
				enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + 2 * attack1_power * (Global.wild_rat_attack / Global.rat_defence)))
				current_rat_hp.value = current_rat_hp.value - enemy_damage
				Global.rat_hp = current_rat_hp.value
				print("enemy did: ", enemy_damage, "damage")
				enemy_moved = true
			
			if enemy_attack == 1: 
				if randf() < ENEMY_HIT_CHANCE:
					enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + 2 * attack2_power * (Global.wild_rat_attack / Global.rat_defence)))
					current_rat_hp.value = current_rat_hp.value - enemy_damage
					Global.rat_hp = current_rat_hp.value
					print("enemy did: ", enemy_damage, "damage")
					enemy_moved = true
				else:
					print("enemy missed")
					enemy_moved = true
				


func _attack_1() -> void:
	if player_moved == false:
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(1.0).timeout
			damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack1_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			print("you did: ", damage, "damage")
			player_moved = true
		
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack1_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
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
				damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack2_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
				enemy_rat_hp.value = enemy_rat_hp.value - damage
				Global.wild_rat_hp = enemy_rat_hp.value
				print("you did: ", damage, "damage")
			# 3x power but 75% hit chance 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			var hit_chance: float = 0.75 
			if randf() < hit_chance:
				damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack2_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
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
		Global.rat_speed = Global.rat_speed * SPEED_MULTI
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(1.0).timeout
			damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack3_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed / SPEED_MULTI
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((((DAMAGE_SCALING * Global.rat_level) * attack3_power * 0.02) + 2) * (Global.rat_attack / Global.wild_rat_defence)))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed / SPEED_MULTI
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			await get_tree().create_timer(1.0).timeout
			enemy_turn()

func _block() -> void:
	if player_moved == false:
		Global.rat_speed = Global.rat_speed * BLOCK_SPEED_MULTI
		Global.rat_defence = Global.rat_defence * DEFENCE_MULTIPLIER
		Global.rat_speed = Global.rat_speed / BLOCK_SPEED_MULTI
		print("you did: ", damage, "damage")
		blocked = true 
		player_moved = true 
		# defence increases 8x for one turn 
		await get_tree().create_timer(1.0).timeout
		enemy_turn()
	

func _bag_opened() -> void:
	if player_moved == false:
		var new_scene = load("res://Scenes/bag.tscn").instantiate()
		add_child(new_scene)


func net_thrown() -> void:
	if player_moved == false:
		catch_chance = ( ( (3 * enemy_rat_hp.max_value) - (2 * enemy_rat_hp.value) ) * Global.wild_rat_catch_rate) / (3.0  * enemy_rat_hp.max_value)
		player_moved = true
		if randf() < catch_chance:
			Global.party[new_rat] = {
				"level" : Global.wild_rat_level,
				"current_hp" : Global.wild_rat_hp
			}
			Player_auto.party = Global.party
			print(Global.party)
			await get_tree().create_timer(1.0).timeout
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")
		else:
			await get_tree().create_timer(1.0).timeout
			enemy_turn()

func enemy_dead() -> void:
	print("enemy rat done")
	Global.party[Global.lead_rat]["exp"] += ((Global.base_yield * Global.wild_rat_level) / 7) * trainer_bonus
	while Global.party[Global.lead_rat]["exp"] >= pow(Global.rat_level + 1, 3):
		print("level up")
		Global.party[Global.lead_rat]["level"] += 1
		Player_auto.lead_changed()
	await get_tree().create_timer(1.0).timeout
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")

func player_dead() -> void:
	print("your rat is done")
	await get_tree().create_timer(1.0).timeout
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")
