extends Button

const RAT_NET_NAME: String = "Rat net"
const HEAL_SPRAY_NAME: String = "Heal spray"
const COLONISER: String = ": "

var item: String
var combat_ui: Control


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("combat_ui"):
		combat_ui = node


func _process(delta: float) -> void:
	pass


func item_used() -> void:
	
	if item == RAT_NET_NAME:
		if Global.bag.has(item):
			Global.bag[item] -= 1
			get_tree().get_first_node_in_group("bag").bag = Global.bag
			print(Global.bag)
			text = str(item, COLONISER, Global.bag[item])
		
		combat_ui.net_thrown()
		get_tree().get_first_node_in_group("bag").queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://combat_ui/bag.tscn")
		
	elif item == HEAL_SPRAY_NAME:
		if Global.bag.has(item):
			Global.bag[item] -= 1
			get_tree().get_first_node_in_group("bag").bag = Global.bag
			print(Global.bag)
			text = str(item, COLONISER, Global.bag[item])
		
		combat_ui.heal_used()
		get_tree().get_first_node_in_group("bag").queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://combat_ui/bag.tscn")
		
	if Global.bag[item] <= 0:
		queue_free()
