extends Node2D
var points: PackedVector2Array
var drawing = false
var temp_line: Line2D
var cl = Game.color
var total_area = 0.0
var max_area = 1000000.0
var regen = 50000.0
var used_area = 0.0
var original_max_area = max_area
var area_indicator: TextureProgressBar

func _ready():
	points = PackedVector2Array()
	temp_line = Line2D.new()
	temp_line.default_color = Color(0.5, 0.5, 0.5) # White color
	add_child(temp_line)
	area_indicator = get_node("CanvasLayer/ProgressBar")

func calculate_area(new_point):
	var area = 0.0
	for i in range(points.size()):
		var p1 = points[i]
		var p2 = points[(i + 1) %points.size()]
		area += (p1.x - new_point.x) * (p2.y - new_point.y) - (p1.y - new_point.y) * (p2.x - new_point.x)
	return abs(area / 2.0)

func _process(delta):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		used_area -= regen * delta
	area_indicator.value = ((original_max_area - used_area) / original_max_area) * 100
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and max_area > used_area:
		if !drawing:
			drawing = true
			points.clear()
		var mouse_pos = get_global_mouse_position()
		if total_area + calculate_area(mouse_pos) <= (original_max_area - used_area):
			points.append(mouse_pos)
			temp_line.points = points
			total_area += calculate_area(mouse_pos)
	elif drawing:
		drawing = false
		finalize_line()

func finalize_line():
	var line = Line2D.new()
	line.points = points
	line.default_color = cl # Grey color
	add_child(line)

	var body = RigidBody2D.new()
	body.gravity_scale = 0
	body.collision_layer = 2
	body.collision_mask = 0
	add_child(body)

	for i in range(points.size() - 1):
		var collision_shape = CollisionShape2D.new()
		var segment_shape = SegmentShape2D.new()
		segment_shape.a = points[i]
		segment_shape.b = points[i + 1]
		collision_shape.shape = segment_shape
		body.add_child(collision_shape)

	used_area += total_area
	points = PackedVector2Array()
	temp_line.points = points
	total_area = 0.0

	# var collision_polygon = CollisionPolygon2D.new()
	# collision_polygon.polygon = points
	# body.add_child(collision_polygon)
	# used_area += total_area
	# points = PackedVector2Array()
	# temp_line.points = points
	# total_area = 0.0
