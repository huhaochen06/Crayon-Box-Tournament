extends Node2D

var speed = 200  # The speed at which the object will move along the path

func _ready():
    var path_follow = get_node("PathFollow2D")  # Get the PathFollow2D node
    path_follow.unit_offset = 0  # Start at the beginning of the path

func _process(delta):
    var path_follow = get_node("PathFollow2D")  # Get the PathFollow2D node
    path_follow.unit_offset += speed * delta  # Move the PathFollow2D along the path