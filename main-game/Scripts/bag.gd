extends Control

@export var button_scene: PackedScene
@export var button_spawn: VBoxContainer
@export var vbox: VBoxContainer

var bag = {
	"Rat net": 12,
	"Heal spray": 5
}

var item_buttons = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.bag = bag
	print(Global.bag)
	for item in bag:
		var button = button_scene.instantiate()
		button.text = str(item, ": ", bag[item])
		button.item = item
		button.global_position = button_spawn.global_position
		item_buttons[item] = button
		Global.item_buttons = item_buttons
		vbox.add_child(button)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bag = Global.bag
	#update bag when it gets changed (this does not work)
