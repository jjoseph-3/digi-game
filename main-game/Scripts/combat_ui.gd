extends Control

@export var current_rat_hp: ProgressBar
@export var enemy_rat_hp: ProgressBar

var attack_power: int = 5
var damage: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_rat_hp.max_value = Global.rat_hp
	current_rat_hp.value = current_rat_hp.max_value
	enemy_rat_hp.max_value = Global.rat_hp
	enemy_rat_hp.value = enemy_rat_hp.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _attack_1() -> void:
	damage = int(floor((0.5 * (0.2 * (2 * Global.rat_level)) + 2 * attack_power * (Global.rat_attack / Global.rat_defence))))
	enemy_rat_hp.value = enemy_rat_hp.value - damage
