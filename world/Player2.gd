extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score = Game.score.p2
	for i in range(1, score + 1):
		if i > 4:
			break
		var indicator = get_node("ID"+ str(i))
		indicator.modulate.a = 1
