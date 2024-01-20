extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1000.0
const DASH_LENGTH = 0.1
const NORMAL_SPEED = 400.0
const DASH_COOLDOWN = 0.5

@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer = $DashCooldownTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_direction: Vector2
var can_dash = true

func _physics_process(delta):
    if dash_timer.time_left > 0:
        velocity = dash_direction * DASH_SPEED
    else:
        if is_on_floor():
            if dash_cooldown_timer.time_left <= 0:
                $Sprite.texture = load("res://player/box/assets/box-normal.png")
                can_dash = true
        else:
            velocity.y += gravity * delta

        var direction = Input.get_axis("ui_left", "ui_right")
        if direction:
            $Sprite.flip_h = direction < 0
            velocity.x = direction * NORMAL_SPEED
        else:
            velocity.x = move_toward(velocity.x, 0, NORMAL_SPEED)

        # Handle jump.
        if Input.is_action_just_pressed("ui_accept") and is_on_floor():
            velocity.y = JUMP_VELOCITY
        
        # Handle dash.
        if Input.is_action_just_pressed("dash"):
            if can_dash:
                dash_timer.start(DASH_LENGTH)
                dash_cooldown_timer.start(DASH_COOLDOWN)
                $Sprite.texture = load("res://player/box/assets/box-bw.png")
                can_dash = false
                dash_direction = get_direction_from_input()

    move_and_slide()

func get_direction_from_input():
    var move_dir = Vector2()

    if Input.is_action_pressed("ui_left"):
        move_dir.x -= 1
    if Input.is_action_pressed("ui_right"):
        move_dir.x += 1
    if Input.is_action_pressed("ui_up"):
        move_dir.y -= 1
    if Input.is_action_pressed("ui_down"):
        move_dir.y += 1

    if (move_dir == Vector2(0, 0)):
        if $Sprite.flip_h:
            move_dir.x = -1
        else:
            move_dir.x = 1

    return move_dir.normalized()

func _on_dash_timer_timeout():
    velocity = lerp(velocity, Vector2(), 0.5)
