extends Node2D

@export var wild_rat_spawn: PathFollow2D
@export var wild_rat_scene: PackedScene
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _tall_grass_entered(body: Node2D) -> void:
	if body is Player:
		var spawn_chance: float = 0.8
		if randf() < spawn_chance:
			var wild_rat = wild_rat_scene.instantiate()
			wild_rat_spawn.progress_ratio = randf()
			wild_rat.global_position = wild_rat_spawn.global_position
			add_child(wild_rat)
			
		
