extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _item_used() -> void:
	if text == str("Rat net", ": ", Global.bag["Rat net"]):
		Global.bag["Rat net"] -= 1
		print(str("Rat net", ": ", Global.bag["Rat net"]))
		print("button clicked")
		
