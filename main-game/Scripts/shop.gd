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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		button.text = str(MONEY, COLONISER, Global.bag[MONEY])
		button.item = MONEY
		button_spawn.add_child(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.player_not_controllable.emit()


func shop_exited() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Level.tscn")
	


func bought_heal_spray() -> void:
	if Global.bag[MONEY] >= HEAL_SPRAY_COST:
		Global.bag[MONEY] -= HEAL_SPRAY_COST
		Global.bag[HEAL_SPRAY] += 1
		button.text = str(MONEY, COLONISER, Global.bag[MONEY])

func bought_rat_net() -> void:
	if Global.bag[MONEY] >= RAT_NET_COST:
		Global.bag[MONEY] -= RAT_NET_COST
		Global.bag[RAT_NET] += 1
		button.text = str(MONEY, COLONISER, Global.bag[MONEY])
