extends Node2D

var available_powerups = [
	"res://power/cards/cocktail.tres",
	"res://power/cards/dasher.tres",
	"res://power/cards/efficiency.tres",
	"res://power/cards/quantum.tres",
	"res://power/cards/sprinter.tres",
	"res://power/cards/tanker.tres"
]

var base_card = "res://power/card.tscn"

func get_random_2_powerups():
	var powerups = []
	for i in range(2):
		var powerup = available_powerups[randi() % available_powerups.size()]
		powerups.append(powerup)
		available_powerups.erase(powerups[i])
	return powerups

# Called when the node enters the scene tree for the first time.
func _ready():
	var powerups = get_random_2_powerups()
	for i in range(2):
		var card = load(base_card).instantiate()
		card.resource = load(powerups[i])
		add_child(card)
		if i == 0:
			card.position = $Card1Pos.position
		else:
			card.position = $Card2Pos.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
