extends Node2D

var allLevels = ["res://world/world_2/world_2.tscn"]

func create_instance(add):
	var scene = load(add)
	var scene_instance = scene.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add a random level to the scene as child
	var level = allLevels[randi() % allLevels.size()]
	var world = create_instance(level)
	self.add_child(world)

	var spawn = world.get_node("Spawn")
	print(spawn.global_position)
	$Box.global_position = spawn.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
