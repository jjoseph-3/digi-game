extends Button

const RAT_NET_NAME: String = "Rat net"

var item: String
var combat_ui: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("combat_ui"):
		combat_ui = node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _item_used() -> void:
	if Global.bag.has(item):
		Global.bag[item] -= 1
		get_tree().get_first_node_in_group("bag").bag = Global.bag
		print(Global.bag)
		text = str(item, ": ", Global.bag[item])
		
		if Global.bag[item] <= 0:
			queue_free()
		
		if item == RAT_NET_NAME:
			combat_ui.net_thrown()
			get_tree().get_first_node_in_group("bag").queue_free()
			get_tree().call_deferred("change_scene_to_file", "res://combat_ui/bag.tscn")
		
