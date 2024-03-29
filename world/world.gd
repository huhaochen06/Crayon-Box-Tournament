extends Node2D

var allLevels = ["res://world/world_1/world_1.tscn", "res://world/world_2/world_2.tscn", "res://world/world_3/world_3.tscn"]

@onready var stopwatch = $CanvasLayer/Stopwatch
@onready var timer = $Timer

func _on_Button_pressed():
	timer.start()

func _on_Timer_timeout():
	get_tree().paused = false

func create_instance(add):
	var scene = load(add)
	var scene_instance = scene.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = "res://world/countdown.tscn"
	var scene = load(overlay).instantiate()
	self.add_child(scene)
	timer.connect("timeout", _on_Timer_timeout)
	timer.start()
	get_tree().paused = true
	
	# Add a random level to the scene as child
	if Game.split == 2:
		Game.current_world = allLevels[randi() % allLevels.size()]
	elif Game.split == 0:
		Game.current_world = allLevels[randi() % allLevels.size()]
		Game.split = 1

	var world = create_instance(Game.current_world)
	self.add_child(world)

	var spawn = world.get_node("Spawn")
	print(spawn.global_position)
	$Box.global_position = spawn.global_position

	var goal = world.get_node("Goal")
	goal.connect("body_entered", on_goal_entered)

func _process(delta):
	if Input.is_action_pressed("start_stopwatch") and !stopwatch.counting:
		stopwatch.start()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main.tscn")

func on_goal_entered(body):
	if body.name != "Box":
		return

	stopwatch.stop()
	Game.times[Game.current_player] = stopwatch.time
	print(Game.times)
	if Game.current_player == 'p1':
		Game.split = 1
		Game.current_player = 'p2'
		get_tree().reload_current_scene()

	else:
		Game.split = 2
		Game.current_player = 'p1'
		if Game.times['p1'] < Game.times['p2']:
			Game.score['p1'] += 1
			Game.loser = 'p2'
		else:
			Game.score['p2'] += 1
			Game.loser = 'p1'
		if Game.score['p1'] == 3 or Game.score['p2'] == 3:
			on_game_over()
		else:
			get_tree().change_scene_to_file("res://power/PowerScreen.tscn")

func on_game_over():
	get_tree().paused = true
	var end_game_screen = create_instance("res://world/common/endgame.tscn")
	self.add_child(end_game_screen)
