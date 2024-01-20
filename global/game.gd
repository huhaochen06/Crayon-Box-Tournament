extends Node

var color = Color(0, 0, 0)

# Box parameters
var movement_speed = 400.0
var size = Vector2(1, 1)
var phase_duration = 0.5
var phase_cooldown = 5.0
var dash_speed = 1000.0
var dash_duration = 0.2

# Game progress
var score = {
    "p1": 0,
    "p2": 0
}
var split = 0
var current_player = "p1"
var times = {
	"p1": 0,
	"p2": 0
}