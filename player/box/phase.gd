extends Node2D

@onready var timer = get_node("PhaseCooldownTimer")
@onready var pb = get_node("PhaseProgress")

func _ready():
	timer.wait_time = pb.value

func _process(delta):
	#print(timer.time_left)
	pb.value = timer.time_left / timer.wait_time * 100
	if timer.time_left <= 0:
		# Make progress bar background opacity 0
		pb.modulate.a = 0
	else:
		pb.modulate.a = 0.2