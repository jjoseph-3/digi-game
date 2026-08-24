extends Control

const COLONISER: String = ": "

var bag: Dictionary
var item_buttons: Dictionary

@export var button_scene: PackedScene
@export var button_spawn: VBoxContainer
@export var vbox: VBoxContainer


func _ready() -> void:
	bag = Global.bag
	print(Global.bag)
	
	for item in bag:
		var button = button_scene.instantiate()
		button.text = str(item, COLONISER, bag[item])
		button.item = item
		button.global_position = button_spawn.global_position
		item_buttons[item] = button
		Global.item_buttons = item_buttons
		vbox.add_child(button) 
	# Creates buttons using the bag dictionary
	
	
func _process(delta: float) -> void:
	pass


func bag_closed() -> void:
	queue_free()
