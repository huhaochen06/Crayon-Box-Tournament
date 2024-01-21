extends CanvasLayer

var game_winner = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Gamver")
	if Game.score['p1'] == 3:
		game_winner = "Player 1"
	else:
		game_winner = "Player 2"
	$Label.text = game_winner + " wins!"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
