extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_DISTANCE = 100.0  # Distance of the dash
const DASH_COOLDOWN = 1.0  # Cooldown of the dash
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_timer = 0.0
var dash_direction = 0

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity * delta
# As good practice, you should replace UI actions with custom gameplay actions.
    var direction = Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    # Handle dash.
    if Input.is_action_just_pressed("dash") and dash_timer <= 0:
            dash_direction = Input.get_axis("ui_left", "ui_right")
            if dash_direction != 0:
                var dash_vector = Vector2(dash_direction, 0) * DASH_DISTANCE
                var collision = move_and_collide(dash_vector)
                if collision:
                    # Handle collision here if needed
                    pass
                dash_timer = DASH_COOLDOWN
    # Get the input direction and handle the movement/deceleration.
    
    # Update dash timer.
    if dash_timer > 0:
        dash_timer -= delta

    move_and_slide()

