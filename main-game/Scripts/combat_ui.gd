extends Control

const JOHOVIAN_NAME: Array = ["Johovian", "Wild Johovian"]
const KARTARIAN_NAME: Array = ["Kartarian", "Wild Kartarian"]
const WILD_NAME_MODIFYER: String = "Wild "
const NEW_RAT_LEVEL: String = "level"
const NEW_RAT_HP: String = "current_hp"
const NEW_RAT_MAX_HP: String = "max_hp"
const NEW_RAT_EXP: String = "exp"
const PLAYER_SCALE: float = 5.0
const ENEMY_SCALE: float = 8.0
const TURN_DELAY: float = 0.5
const OPTION_ONE: int = 1
const OPTION_TWO: int = 2
const LOW_HP_THRESHOLD: float = 0.25
const SPEED_MULTI: float = 2.0
const BLOCK_SPEED_MULTI: float = 50.0
const HIT_CHANCE: float = 0.75
const DEFENCE_MULTIPLIER: float = 10.0
const DAMAGE_SCALING: float = 0.2
const DAMAGE_FLOOR: float = 2.0
const MAX_HP_MULTI: float = 3.0
const CURRENT_HP_MULTI: float = 2.0
const EXP_DIVIDER: float = 7.0
const EXP_CURVE: float = 3.0
const MONEY: String = "Money"
const JOHO_MONEY_MULTI: float = 5.0
const KART_MONEY_MULTI: float = 8.0
const BASIC_ATTACK_POWER: float = 5
const POWER_ATTACK_POWER: float = 10
const QUICK_ATTACK_POWER: float = 3

var player_moved: bool = false
var enemy_moved: bool = false
var blocked: bool = false 
var enemy_alive: bool = true 
var player_alive: bool = true 
var damage: int  
var enemy_damage: int
var catch_chance: float:
	set(new_value):
		catch_chance = clampf(new_value, 0, 1)
var player: CharacterBody2D
var new_rat: String
var trainer_bonus: float = 1
var current_rat_max_hp_percent: float

@export var current_rat_hp: ProgressBar
@export var enemy_rat_hp: ProgressBar
@export var player_spawn: Marker2D
@export var johovian_sprite_scene: PackedScene
@export var kartarian_sprite_scene:PackedScene
@export var enemy_spawn: Marker2D
@export var enemy_scene: PackedScene
@export var current_rat_level: Label
@export var enemy_rat_level: Label


func _ready() -> void:
	
	current_rat_hp.max_value = Player_auto.party[Global.lead_rat]["max_hp"]
	current_rat_hp.value = Player_auto.party[Global.lead_rat]["current_hp"]
	enemy_rat_hp.max_value = Global.wild_rat_hp
	enemy_rat_hp.value = enemy_rat_hp.max_value
	# Change enemy_rat_hp to match the enemy rat script 
	print(current_rat_hp.max_value)
	print(enemy_rat_hp.max_value)
	
	enemy_rat_level.text = str("Level: ", Global.wild_rat_level)
	current_rat_level.text = str("Level: ", Global.rat_level)
	# Displays level of each rat 
	
	if Global.lead_rat in JOHOVIAN_NAME:
		var player_sprite = johovian_sprite_scene.instantiate()
		player_sprite.scale = Vector2(PLAYER_SCALE, PLAYER_SCALE)
		player_sprite.global_position = player_spawn.global_position
		add_child(player_sprite)
		
	elif Global.lead_rat in KARTARIAN_NAME:
		var player_sprite = kartarian_sprite_scene.instantiate()
		player_sprite.scale = Vector2(PLAYER_SCALE, PLAYER_SCALE)
		player_sprite.global_position = player_spawn.global_position
		add_child(player_sprite)
	
	var enemy_sprite = enemy_scene.instantiate()
	enemy_sprite.scale = Vector2(ENEMY_SCALE, ENEMY_SCALE)
	enemy_sprite.global_position = enemy_spawn.global_position
	add_child(enemy_sprite)
	# Spawns enemy and player sprites
	
	new_rat = WILD_NAME_MODIFYER + str(Global.enemy_type)
	# Sets the name of the new rat (if caught)


func _process(delta: float) -> void:
	Global.player_not_controllable.emit()
	
	if enemy_moved or player_moved == true:
		if enemy_rat_hp.value <= 0 and enemy_alive == true:
			enemy_alive = false
			enemy_dead()
		
		elif current_rat_hp.value <= 0 and player_alive == true:
			player_alive = false
			player_dead()
			
	
	if enemy_moved and player_moved == true:
		enemy_moved = false
		player_moved = false
		# Allows both player and enemy to move again
		if blocked == true:
			Global.rat_defence = Global.rat_defence / DEFENCE_MULTIPLIER
			blocked = false
			# Resets defence of player rat 
	
	
func enemy_turn() -> void:
	if enemy_alive == true and enemy_moved == false:
		if Global.rat_hp <= current_rat_hp.max_value * LOW_HP_THRESHOLD:
			Global.wild_rat_speed = Global.wild_rat_speed * SPEED_MULTI
			enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + DAMAGE_FLOOR
			* QUICK_ATTACK_POWER * (Global.wild_rat_attack / max(Global.rat_defence, 1))))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed / SPEED_MULTI
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# If player hp is less than 1/4 of max enemy does a quick attack
			
		elif Global.wild_rat_hp <= enemy_rat_hp.max_value * LOW_HP_THRESHOLD:
			Global.wild_rat_speed = Global.wild_rat_speed * SPEED_MULTI
			enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + DAMAGE_FLOOR
			* QUICK_ATTACK_POWER * (Global.wild_rat_attack /  max(Global.rat_defence, 1))))
			current_rat_hp.value = current_rat_hp.value - enemy_damage
			Global.rat_hp = current_rat_hp.value
			Global.wild_rat_speed = Global.wild_rat_speed / SPEED_MULTI
			print("enemy did: ", enemy_damage, "damage")
			enemy_moved = true
			# If own hp is less than 1/4 of max enemy does a quick attack
			
		else:
		# Random chance for "normal attack" or "power attack" for enemy
			var enemy_attack = randi_range(1, 2)
			if enemy_attack == OPTION_ONE:
				enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + DAMAGE_FLOOR
				* BASIC_ATTACK_POWER * (Global.wild_rat_attack /  max(Global.rat_defence, 1))))
				current_rat_hp.value = current_rat_hp.value - enemy_damage
				Global.rat_hp = current_rat_hp.value
				print("enemy did: ", enemy_damage, "damage")
				enemy_moved = true
			
			if enemy_attack == OPTION_TWO: 
				if randf() < HIT_CHANCE:
					enemy_damage = int(floor((DAMAGE_SCALING * Global.wild_rat_level) + DAMAGE_FLOOR
					* POWER_ATTACK_POWER * (Global.wild_rat_attack / max(Global.rat_defence, 1))))
					# This is the cleanest way to have this line whist being close or on the limit
					current_rat_hp.value = current_rat_hp.value - enemy_damage
					Global.rat_hp = current_rat_hp.value
					print("enemy did: ", enemy_damage, "damage")
					enemy_moved = true
				else:
					print("enemy missed")
					enemy_moved = true


func basic_attack() -> void:
	if player_moved == false:
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(TURN_DELAY).timeout
			damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR 
			* BASIC_ATTACK_POWER * (Global.rat_attack /  max(Global.wild_rat_defence, 1))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			print("you did: ", damage, "damage")
			player_moved = true
		
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR 
			* BASIC_ATTACK_POWER * (Global.rat_attack / max(Global.wild_rat_defence, 1))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			print("you did: ", damage, "damage")
			player_moved = true
			await get_tree().create_timer(TURN_DELAY).timeout
			enemy_turn()


func power_attack() -> void:
	if player_moved == false:
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(TURN_DELAY).timeout
			if randf() < HIT_CHANCE:
				damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR
				* POWER_ATTACK_POWER * (Global.rat_attack / max(Global.wild_rat_defence, 1))))
				enemy_rat_hp.value = enemy_rat_hp.value - damage
				Global.wild_rat_hp = enemy_rat_hp.value
				print("you did: ", damage, "damage")
			# 2x power but 75% hit chance 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			if randf() < HIT_CHANCE:
				damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR
				* POWER_ATTACK_POWER * (Global.rat_attack / max(Global.wild_rat_defence, 1))))
				enemy_rat_hp.value = enemy_rat_hp.value - damage
				Global.wild_rat_hp = enemy_rat_hp.value
				print("you did: ", damage, "damage")
				player_moved = true
				await get_tree().create_timer(TURN_DELAY).timeout
				enemy_turn()

			else:
				print("you missed") 
				player_moved = true
				await get_tree().create_timer(TURN_DELAY).timeout
				enemy_turn()
		# 2x power but 75% hit chance


func quick_attack() -> void:
	if player_moved == false:
		Global.rat_speed = Global.rat_speed * SPEED_MULTI
		if Global.wild_rat_speed > Global.rat_speed:
			enemy_turn()
			await get_tree().create_timer(TURN_DELAY).timeout
			damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR 
			* QUICK_ATTACK_POWER * (Global.rat_attack / max(Global.wild_rat_defence, 1))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed / SPEED_MULTI
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			
		elif Global.wild_rat_speed <= Global.rat_speed:
			damage = int(floor((DAMAGE_SCALING * Global.rat_level) + DAMAGE_FLOOR 
			* QUICK_ATTACK_POWER * (Global.rat_attack / max(Global.wild_rat_defence, 1))))
			enemy_rat_hp.value = enemy_rat_hp.value - damage
			Global.wild_rat_hp = enemy_rat_hp.value
			Global.rat_speed = Global.rat_speed / SPEED_MULTI
			print("you did: ", damage, "damage")
			# "Quick attack" 
			player_moved = true
			await get_tree().create_timer(TURN_DELAY).timeout
			enemy_turn()


func block() -> void:
	if player_moved == false:
		Global.rat_speed = Global.rat_speed * BLOCK_SPEED_MULTI
		Global.rat_defence = Global.rat_defence * DEFENCE_MULTIPLIER
		Global.rat_speed = Global.rat_speed / BLOCK_SPEED_MULTI
		print("you did: ", damage, "damage")
		blocked = true 
		player_moved = true 
		# Defence increases 10x for one turn 
		await get_tree().create_timer(TURN_DELAY).timeout
		enemy_turn()
	

func bag_opened() -> void:
	if player_moved == false:
		var new_scene = load("res://Scenes/bag.tscn").instantiate()
		add_child(new_scene)


func heal_used() -> void:
	if player_moved == false:
		current_rat_hp.value = Global.rat_max_hp
		player_moved = true
		await get_tree().create_timer(TURN_DELAY).timeout
		enemy_turn()
	
	else: 
		await get_tree().create_timer(TURN_DELAY).timeout
		enemy_turn()


func net_thrown() -> void:
	if player_moved == false:
		catch_chance = (((MAX_HP_MULTI * enemy_rat_hp.max_value) - (CURRENT_HP_MULTI
		* enemy_rat_hp.value)) * Global.wild_rat_catch_rate) \
		/ (MAX_HP_MULTI * enemy_rat_hp.max_value)
		# Checks for player_moved and calculates a catch chance
		player_moved = true
		
		if randf() < catch_chance:
			Global.party[new_rat] = {
				NEW_RAT_LEVEL : Global.wild_rat_level,
				NEW_RAT_HP : Global.wild_rat_hp,
				NEW_RAT_MAX_HP : Global.wild_rat_max_hp,
				NEW_RAT_EXP : 0
			}

			Player_auto.party = Global.party
			print(Global.party)
			await get_tree().create_timer(TURN_DELAY).timeout
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")
		
		else:
			await get_tree().create_timer(TURN_DELAY).timeout
			enemy_turn()


func enemy_dead() -> void:
	Global.current_rat_max_hp_percent = current_rat_hp.value \
	/ Player_auto.party[Global.lead_rat]["max_hp"]
	print(Global.current_rat_max_hp_percent, "%")
	# Calculates the current rats % of max health
	print("enemy rat done")
	
	if str(Global.enemy_type) in JOHOVIAN_NAME:
		Global.bag[MONEY] += Global.wild_rat_level * JOHO_MONEY_MULTI
	
	elif str(Global.enemy_type) in KARTARIAN_NAME:
		Global.bag[MONEY] += Global.wild_rat_level * KART_MONEY_MULTI
	
	print("$", Global.bag[MONEY])
	# Adds money to the players bag
	
	Global.party[Global.lead_rat]["exp"] += ((Global.base_yield * Global.wild_rat_level)
	/ EXP_DIVIDER) * trainer_bonus
	while Global.party[Global.lead_rat]["exp"] >= pow(Global.rat_level + 1, EXP_CURVE):
		print("level up")
		Global.party[Global.lead_rat]["level"] += 1
		Player_auto.lead_changed(true)
	# Calculates exp gains and if the rat levels up
	
	Player_auto.global_position = Vector2.ZERO
	await get_tree().create_timer(TURN_DELAY).timeout
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")


func player_dead() -> void:
	print("your rat is done")
	await get_tree().create_timer(TURN_DELAY).timeout
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")



func pause_menu() -> void:
	var new_scene = load("res://Scenes/pause_menu.tscn").instantiate()
	add_child(new_scene)
