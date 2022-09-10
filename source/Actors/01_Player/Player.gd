#Inherits Actor Code
extends Actor
#------------------------------------------------------------------------------#
#Variables
var direction = 0
var dir_prev = 0
var dir_new = 0
#Bools Variables
var is_grounded: bool = false
var is_jumping: bool = false
var found_wall: bool = false
var found_ledge: bool = false
#OnReady Variables
#Detectors
onready var wallDetectors: Node2D = $Facing/WallDetectors
onready var wallDetector1: RayCast2D = $Facing/WallDetectors/WallDetector1
onready var wallDetector2: RayCast2D = $Facing/WallDetectors/WallDetector2
onready var ledgeDetector: RayCast2D = $Facing/WallDetectors/LedgeDetector
onready var groundDetectors: Node2D = $Facing/GroundDetectors
onready var safeFall: RayCast2D = $Facing/SafeFallDetector
#Animation Nodes
onready var spritePlayer: AnimationPlayer = $AnimationPlayers/AnimationPlayer
onready var animTree: AnimationTree = $AnimationPlayers/AnimationTree
onready var playBack = animTree.get("parameters/playback")
onready var current_state = playBack.get_current_node()
#Timers
onready var coyoteTimer: Timer = $CoyoteTimer
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	gravity = 2 * max_jumpHeight / pow(jump_duration, 2)
	min_jumpMotion = -sqrt(2 * gravity * min_jumpHeight)
	max_jumpMotion = -sqrt(2 * gravity * max_jumpHeight)
#------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta):
	motion.y += gravity * delta
#------------------------------------------------------------------------------#
#Player Movement
func apply_movement():
	motion = move_and_slide(motion, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	var was_on_floor = is_grounded
	is_grounded = check_grounded()
	found_ledge = check_ledge()
	found_wall = check_wall()
	if !is_grounded && was_on_floor: coyoteTimer.start()
	if is_grounded: is_jumping = false
#------------------------------------------------------------------------------#
#Move Direction
func moveDirection():
	dir_prev = direction
	direction = (int(Input.is_action_pressed(G.actions.RIGHT)) -
				(int(Input.is_action_pressed(G.actions.LEFT))))
	dir_new = direction
#------------------------------------------------------------------------------#
#Move Handler
func handle_movement():
	motion.x = lerp(motion.x, max_speed * direction, weight())
	if Input.is_action_pressed(G.actions.RUN): max_speed = run_speed
	if Input.is_action_just_released(G.actions.RUN): max_speed = walk_speed
#------------------------------------------------------------------------------#
func apply_facing():
	pass
#------------------------------------------------------------------------------#
#Player Weight
func weight():
	#Ground Weight
	if (is_grounded) || (!coyoteTimer.is_stopped()):
		#Slow-to-Stop
		if (!Input.is_action_pressed(G.actions.RIGHT) &&
			!Input.is_action_pressed(G.actions.LEFT)): return 0.15
		#Running
		elif motion.x != 0 && max_speed == run_speed: return 0.05
		#Walking
		else: return 0.1
	#Air Weight
	else: return 0.1
#------------------------------------------------------------------------------#
#World Detection
#Ground Detection
func check_grounded():
	for groundDetector in groundDetectors.get_children():
		if groundDetector.is_colliding(): return true
	return false
#Wall Detection
func check_wall():
	if (wallDetector2.is_colliding() &&
		ledgeDetector.is_colliding() &&
		!safeFall.is_colliding()): return true
	return false
#Ledge Detection
func check_ledge():
	if (!ledgeDetector.is_colliding() &&
		 wallDetector1.is_colliding() &&
		!safeFall.is_colliding()): return true
	return false
