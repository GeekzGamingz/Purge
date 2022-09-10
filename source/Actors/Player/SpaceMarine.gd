#Inherits Actor Code
extends Actor
#-------------------------------------------------------------------------------------------------#
#Variables
var direction = 0
var dir_prev = 0
var dir_new = 0
#Bools Variables
var grounded = false
var jumping = false
var wall = false
var ledge = false
#OnReady Variables
#Detectors
onready var wallDetectors = $Facing/WallDetectors
onready var wallDetector1 = $Facing/WallDetectors/WallDetector1
onready var wallDetector2 = $Facing/WallDetectors/WallDetector2
onready var ledgeDetector = $Facing/WallDetectors/LedgeDetector
onready var groundDetectors = $Facing/GroundDetectors
onready var safeFall = $Facing/SafeFallDetector
#Animation Nodes
onready var spritePlayer = $AnimationPlayers/AnimationPlayer
onready var animTree = $AnimationPlayers/AnimationTree
onready var playBack = animTree.get("parameters/playback")
onready var current_state = playBack.get_current_node()
#Timers
onready var coyoteTimer = $CoyoteTimer
#-------------------------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	gravity = 2 * max_jumpHeight / pow(jump_duration, 2)
	min_jumpMotion = -sqrt(2 * gravity * min_jumpHeight)
	max_jumpMotion = -sqrt(2 * gravity * max_jumpHeight)
#-------------------------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta):
	motion.y += gravity * delta
#-------------------------------------------------------------------------------------------------#
#Player Movement
func apply_movement():
	motion = move_and_slide(motion, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	var was_on_floor = grounded
	grounded = check_grounded()
	ledge = check_ledge()
	wall = check_wall()
	if !grounded && was_on_floor:
		coyoteTimer.start()
	if grounded:
		jumping = false
#-------------------------------------------------------------------------------------------------#
#Move Direction
func moveDirection():
	dir_prev = direction
	direction = (int(Input.is_action_pressed("move_right")) -
				(int(Input.is_action_pressed("move_left"))))
	dir_new = direction
#-------------------------------------------------------------------------------------------------#
#Move Handler
func handle_movement():
	motion.x = lerp(motion.x, max_speed * direction, weight())
	if direction > 0:
		set_facing(FACING_RIGHT)
	elif direction < 0:
		set_facing(FACING_LEFT)
	if Input.is_action_pressed("action_run"):
		max_speed = run_speed
	if Input.is_action_just_released("action_run"):
		max_speed = walk_speed
#-------------------------------------------------------------------------------------------------#
#Player Weight
func weight():
	#Ground Weight
	if (grounded) || (!coyoteTimer.is_stopped()):
		#Slow-to-Stop
		if (!Input.is_action_pressed("move_right") &&
			!Input.is_action_pressed("move_left")):
			return 0.15
		#Running
		elif motion.x != 0 && max_speed == run_speed:
			return 0.05
		#Walking
		else:
			return 0.1
	#Air Weight
	else:
		return 0.1
#-------------------------------------------------------------------------------------------------#
#World Detection
#Ground Detection
func check_grounded():
	for groundDetector in groundDetectors.get_children():
		if groundDetector.is_colliding():
			return true
	return false
#Wall Detection
func check_wall():
	if (wallDetector2.is_colliding() &&
		ledgeDetector.is_colliding() &&
		!safeFall.is_colliding()):
			return true
	return false
#Ledge Detection
func check_ledge():
	if (!ledgeDetector.is_colliding() &&
		 wallDetector1.is_colliding() &&
		!safeFall.is_colliding()):
			return true
	return false
