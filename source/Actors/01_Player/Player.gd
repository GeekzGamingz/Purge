#Inherits Actor Code
extends Actor
#------------------------------------------------------------------------------#
#Variables
var direction = 0
var dir_prev = 0
var dir_new = 0
#OnReady Variables
#Sprites
onready var shoulder: Node2D = $Facing/Shoulder
#Timers
onready var coyoteTimer: Timer = $Timers/CoyoteTimer
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
	#Direction
	dir_prev = direction
	direction = (int(Input.is_action_pressed(G.actions.RIGHT)) -
				(int(Input.is_action_pressed(G.actions.LEFT))))
	dir_new = direction
	#Motion
	motion.x = lerp(motion.x, max_speed * direction, weight())
	motion = move_and_slide(motion, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if Input.is_action_pressed(G.actions.RUN): max_speed = run_speed
	if Input.is_action_just_released(G.actions.RUN): max_speed = walk_speed
	#World Checks
	var was_on_floor = is_grounded
	is_grounded = check_grounded()
	found_ledge = check_ledge()
	found_wall = check_wall()
	if !is_grounded && was_on_floor: coyoteTimer.start()
	if is_grounded: is_jumping = false
#------------------------------------------------------------------------------#
#Applies Facing
func apply_facing():
	if get_global_mouse_position().x < self.global_position.x:
		is_flipped = true
		for sprite in facing.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_h = true
		for sprite in shoulder.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_h = true
		for detector in wallDetectors.get_children():
			detector.position.x = -3.5
			detector.cast_to.y = -5
	else:
		is_flipped = false
		for sprite in facing.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_h = false
		for sprite in shoulder.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_h = false
		for detector in wallDetectors.get_children():
			detector.position.x = 3.5
			detector.cast_to.y = 5
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
