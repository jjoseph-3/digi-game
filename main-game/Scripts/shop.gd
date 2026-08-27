extends Control

const MONEY: String = "Money"
const COLONISER: String = ": "
const HEAL_SPRAY_COST: int = 50
const HEAL_SPRAY: String = "Heal spray"
const RAT_NET_COST: int = 20
const RAT_NET: String = "Rat net"

@export var button_scene: PackedScene
@export var button_spawn: Marker2D

@onready var button = button_scene.instantiate()


func _ready() -> void:
	# Changes the buttons text to match the players bag
	button.text = str(MONEY, COLONISER, Global.bag[MONEY])
	button.item = MONEY
	button_spawn.add_child(button)


func _process(delta: float) -> void:
	Global.player_not_controllable.emit()


func shop_exited() -> void:
	queue_free()


func bought_heal_spray() -> void:
	# Checks money and 'buys' new things for the player
	if Global.bag[MONEY] >= HEAL_SPRAY_COST:
		Global.bag[MONEY] -= HEAL_SPRAY_COST
		Global.bag[HEAL_SPRAY] += 1
		button.text = str(MONEY, COLONISER, Global.bag[MONEY])


func bought_rat_net() -> void:
	# Checks money and 'buys' new things for the player
	if Global.bag[MONEY] >= RAT_NET_COST:
		Global.bag[MONEY] -= RAT_NET_COST
		Global.bag[RAT_NET] += 1
		button.text = str(MONEY, COLONISER, Global.bag[MONEY])
