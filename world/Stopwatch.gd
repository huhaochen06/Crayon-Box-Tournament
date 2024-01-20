extends Label

var time
var counting

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "0.00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		time += delta
		text = str(snapped(time, 0.01))

func start():
	time = 0.00
	counting = true

func stop():
	counting = false
	