extends Node2D

@export var resource: PlayerModifiers:
	set(value):
		resource = value

@onready var texture = $Button/Texture
@onready var card_name = $Button/Texture/Name
@onready var card_description = $Effects

var pressed = false

func parse_modifiers():
	if round(resource.movement_speed) != 0:
		card_description.text += str(round(resource.movement_speed)) + "% Mvnt spd" + "\n"
	if resource.size != Vector2(1, 1):
		card_description.text += str(round(resource.size.x * 100)) + "% Size" + "\n"
	if round(resource.phase_duration) != 0:
		card_description.text += str(round(resource.phase_duration)) + "% Phase dur" + "\n"
	if round(resource.phase_cooldown) != 0:
		card_description.text += str(round(resource.phase_cooldown)) + "% Phase cd" + "\n"
	if round(resource.dash_speed) != 0:
		card_description.text += str(round(resource.dash_speed)) + "% Dash spd" + "\n"
	if round(resource.dash_duration) != 0:
		card_description.text += str(round(resource.dash_duration)) + "% Dash dur" + "\n"

# Called when the node enters the scene tree for the first time.
func _ready():
	texture.texture = resource.card_texture
	card_name.text = resource.card_name
	parse_modifiers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_mouse_entered():
	if pressed:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.08).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_exited():
	if pressed:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08).set_ease(Tween.EASE_OUT)

func _on_button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			pressed = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", Vector2(0, 0), 0.3).set_ease(Tween.EASE_OUT)

			if resource.movement_speed != 0:
				Game.defaults[Game.loser].speed *= 1 + resource.movement_speed / 100

			if resource.size != Vector2(1, 1):
				Game.defaults[Game.loser].size *= resource.size

			if resource.phase_duration != 0:
				Game.defaults[Game.loser].phase_duration *= 1 + resource.phase_duration / 100

			if resource.phase_cooldown != 0:
				Game.defaults[Game.loser].phase_cooldown *= 1 + resource.phase_cooldown / 100

			if resource.dash_speed != 0:
				Game.defaults[Game.loser].dash_speed *= 1 + resource.dash_speed / 100

			if resource.dash_duration != 0:
				Game.defaults[Game.loser].dash_duration *= 1 + resource.dash_duration / 100

			Game.powerups[Game.loser].append(resource)

			get_tree().change_scene_to_file("res://world/World.tscn")