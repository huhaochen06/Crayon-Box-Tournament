extends CharacterBody2D

var NORMAL_SPEED = Game.movement_speed
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY = -800 # New constant for wall jump velocity
const WALL_SLIDE_SPEED = 6000 # New constant for wall slide speed

var DASH_SPEED = Game.dash_speed
var DASH_DURATION = Game.dash_duration
const DASH_COOLDOWN = 0.5

var PHASE_DURATION = Game.phase_duration
var PHASE_COOLDOWN = Game.phase_cooldown
var box_size = Game.size

@onready var dash_timer = $Dash/DashTimer
@onready var dash_cooldown_timer = $Dash/DashCooldownTimer
@onready var phase_timer = $Phase/PhaseTimer
@onready var phase_cooldown_timer = $Phase/PhaseCooldownTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_direction: Vector2
var can_dash = true
var is_touching_wall = false # New variable to track if the character is touching a wall
var can_phase = true

func _ready():
    # Set size to box_size
    self.scale = box_size

func _physics_process(delta):
    is_touching_wall = is_on_wall() # Check if the character is touching a wall

    if dash_timer.time_left > 0:
        velocity = dash_direction * DASH_SPEED
    else:
        if is_on_floor():
            if dash_cooldown_timer.time_left <= 0:
                $Sprite.texture = load("res://player/box/assets/box-normal.png")
                can_dash = true
        else:
            if is_touching_wall: # If the character is touching a wall
                if Input.is_action_just_pressed("ui_accept"): # And the jump button is pressed
                    # get the normal of the wall and multiply it by the wall jump velocity
                    dash_timer.start(DASH_DURATION)
                    var player_direction
                    if $Sprite.flip_h:
                        player_direction = 1
                    else:
                        player_direction = -1
                    dash_direction = Vector2(player_direction, - 1).normalized() / 2
                else:
                    
                    if get_slide_collision(0).get_normal().x > 0: # If the character is touching a wall on the right
                        if Input.is_action_pressed("ui_left"): # And the left button is pressed
                            velocity.y = WALL_SLIDE_SPEED * delta # Slide down the wall
                        else:
                            velocity.y += gravity * delta
                    else:
                        if Input.is_action_pressed("ui_right"): # If the character is touching a wall on the left
                            velocity.y = WALL_SLIDE_SPEED * delta # Slide down the wall
                        else:
                            velocity.y += gravity * delta
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
                dash_timer.start(DASH_DURATION)
                dash_cooldown_timer.start(DASH_COOLDOWN)
                $Sprite.texture = load("res://player/box/assets/box-bw.png")
                can_dash = false
                dash_direction = get_direction_from_input()

        # Handle phase.
        if Input.is_action_just_pressed("ability"):
            if can_phase:
                phase_timer.start(PHASE_DURATION)
                phase_cooldown_timer.start(PHASE_COOLDOWN)
                # Change opacity of the character
                $Sprite.modulate.a = 0.5
                # change collision layer
                set_collision_mask_value(2, false)
                can_phase = false
            
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

func _on_phase_timer_timeout():
    $Sprite.modulate.a = 1.0
    set_collision_mask_value(2, true)

func _on_phase_cooldown_timer_timeout():
    can_phase = true