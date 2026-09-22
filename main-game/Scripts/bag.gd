extends Control

const COLONISER: String = ": "

@export var button_scene: PackedScene
@export var button_spawn: VBoxContainer
@export var vbox: VBoxContainer

var bag: Dictionary
var item_buttons: Dictionary


func _ready() -> void:
	bag = Global.bag
	print(Global.bag)
	
	# Creates buttons using the bag dictionary
	for item in bag:
		var button = button_scene.instantiate()
		button.text = str(item, COLONISER, bag[item])
		button.item = item
		button.global_position = button_spawn.global_position
		item_buttons[item] = button
		Global.item_buttons = item_buttons
		vbox.add_child(button)


func _process(_delta: float) -> void:
	pass


func bag_closed() -> void:
	queue_free()
