extends Node2D

var allLevels = ["res://world/world_1/world_1.tscn"]

@onready var stopwatch = $CanvasLayer/Stopwatch

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

	var goal = world.get_node("Goal")
	goal.connect("body_entered", on_goal_entered)

func _process(delta):
	if Input.is_action_just_pressed("start_stopwatch") and !stopwatch.counting:
		stopwatch.start()

func on_goal_entered(body):
	if body.name != "Box":
		return

	stopwatch.stop()
	Game.times[Game.current_player] = stopwatch.time
	print(Game.times)
	if Game.current_player == 'p1':
		Game.current_player = 'p2'
	else:
		Game.current_player = 'p1'
		if Game.times['p1'] < Game.times['p2']:
			Game.score['p1'] += 1
		else:
			Game.score['p2'] += 1

	if Game.score['p1'] == 3 or Game.score['p2'] == 3:
		print("Game over")
	else:
		get_tree().reload_current_scene()