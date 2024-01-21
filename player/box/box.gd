extends CharacterBody2D

var DASH_SPEED = Game.defaults[Game.current_player].dash_speed
var DASH_DURATION = Game.defaults[Game.current_player].dash_duration
var DASH_COOLDOWN = Game.defaults[Game.current_player].dash_cooldown

var PHASE_DURATION = Game.defaults[Game.current_player].phase_duration
var PHASE_COOLDOWN = Game.defaults[Game.current_player].phase_cooldown
var box_size = Game.defaults[Game.current_player].size

@onready var dash_timer = $Dash/DashTimer
@onready var dash_cooldown_timer = $Dash/DashCooldownTimer
@onready var phase_timer = $Phase/PhaseTimer
@onready var phase_cooldown_timer = $Phase/PhaseCooldownTimer

var dash_direction: Vector2
var can_dash = true
var can_phase = true

func _ready():
    # Set size to box_size
    self.scale = box_size

func _on_dash_timer_timeout():
    velocity = lerp(velocity, Vector2(), 0.5)

func _on_phase_timer_timeout():
    $Sprite.modulate.a = 1.0
    set_collision_mask_value(2, true)

func _on_phase_cooldown_timer_timeout():
    can_phase = true

var SPEED = Game.defaults[Game.current_player].speed
const JUMP_POWER = -1500

const ACCELERATION = 50
const FRICTION = 70
const MAX_JUMPS = 1
var current_jumps = 1
var gravity = 90

func _physics_process(_delta):
    var input_dir: Vector2 = input()

    if Input.is_action_just_pressed("dash")&&can_dash:
        dash_timer.start(DASH_DURATION)
        dash_cooldown_timer.start(DASH_COOLDOWN)
        $Sprite.texture = load("res://player/box/assets/box-bw.png")
        can_dash = false
        dash_direction = dash_input()

    if dash_timer.time_left > 0:
        dash()
        player_movement()
        return
    else:
        if dash_cooldown_timer.time_left <= 0:
            if is_on_floor():
                $Sprite.texture = load("res://player/box/assets/box-normal.png")
                can_dash = true

    if input_dir != Vector2.ZERO:
        accerelate(input_dir)
        if input_dir.x < 0:
            $Sprite.flip_h = true
        else:
            $Sprite.flip_h = false
    else:
        add_friction()
    
    jump()
    phase()
    wall_jump()
    player_movement()

func input() -> Vector2:
    var input_dir = Vector2.ZERO

    input_dir.x = Input.get_axis("ui_left", "ui_right")
    return input_dir

func phase():
    if Input.is_action_just_pressed("ability"):
        if can_phase:
            phase_timer.start(PHASE_DURATION)
            phase_cooldown_timer.start(PHASE_COOLDOWN)
            # Change opacity of the character
            $Sprite.modulate.a = 0.5
            # change collision layer
            set_collision_mask_value(2, false)
            can_phase = false

func dash_input() -> Vector2:
    var input_dir = Vector2.ZERO

    input_dir.x = Input.get_axis("ui_left", "ui_right")
    input_dir.y = Input.get_axis("ui_up", "ui_down")

    if (input_dir == Vector2.ZERO):
        if $Sprite.flip_h:
            input_dir.x = -1
        else:
            input_dir.x = 1

    return input_dir.normalized()

func dash():
    velocity = dash_direction * DASH_SPEED

func accerelate(direction):
    velocity = velocity.move_toward(direction * SPEED, ACCELERATION)

func add_friction():
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func player_movement():
    move_and_slide()

func jump():
    if Input.is_action_just_pressed("ui_accept"):
        if is_on_floor():
            velocity.y = JUMP_POWER
    else:
        if is_on_wall_only():
            velocity.y += 50
        else:
            velocity.y += gravity

func wall_jump():
    if Input.is_action_just_pressed("ui_accept"):
        if is_on_wall():
            velocity.y = JUMP_POWER
            current_jumps += 1