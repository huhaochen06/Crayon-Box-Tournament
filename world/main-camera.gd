extends Camera2D

var box_character # Reference to the box character node
var zoom_speed = 2 # Speed at which the camera zooms in and out
var min_zoom = Vector2(1, 1) # Minimum zoom level

# Called when the node enters the scene tree for the first time.
func _ready():
	box_character = get_node("/root/World/Box") # Replace with the actual path to the box character node

var follow_speed = 0.05 # Speed at which the camera follows the box character

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var box_position = box_character.global_position
	var viewport_size = get_viewport().size
	var edge_threshold = 100 # Distance from the edge of the viewport to start zooming out

	# Smoothly move the camera towards the box's position
	global_position = global_position.lerp(box_position, follow_speed)
		
	# Prevent zooming in if the crayon is drawing
	if get_node("/root/World/Crayon").drawing:
		return

	var distance_to_edge = min(mouse_position.x, mouse_position.y, viewport_size.x - mouse_position.x, viewport_size.y - mouse_position.y)
	if distance_to_edge < edge_threshold:
		if zoom.x > min_zoom.x and zoom.y > min_zoom.y:
			zoom -= Vector2(zoom_speed, zoom_speed) * delta
	elif zoom.x < 2 and zoom.y < 2:
		zoom += Vector2(zoom_speed, zoom_speed) * delta
