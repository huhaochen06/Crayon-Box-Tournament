extends Node

var color = Color(0, 0, 0)

var defaults = {
    "p1": {
        "color": Color(0, 0, 1),
        "position": Vector2(0, 0),
        "size": Vector2(1, 1),
        "speed": 550,
        "phase_duration": 0.5,
        "phase_cooldown": 5.0,
        "dash_speed": 750.0,
        "dash_duration": 0.2
    },
    "p2": {
        "color": Color(1, 0, 0),
        "position": Vector2(0, 0),
        "size": Vector2(1, 1),
        "speed": 550,
        "phase_duration": 0.5,
        "phase_cooldown": 5.0,
        "dash_speed": 750.0,
        "dash_duration": 0.2
    }
}

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
var current_world = ""
var loser = ""

# Powerup tracking
var powerups = {
    "p1": [],
    "p2": []
}