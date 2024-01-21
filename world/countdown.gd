extends Node2D

@onready var timer = $CanvasLayer/Label/Timer
@onready var label = $CanvasLayer/Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(int(timer.time_left))

func _on_timer_timeout():
	queue_free()
