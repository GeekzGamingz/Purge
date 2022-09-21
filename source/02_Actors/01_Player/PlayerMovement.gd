#Inherits Actor Code
extends Actor
class_name PlayerMovement
#------------------------------------------------------------------------------#
#Variables
var direction = 0
var dir_prev = 0
var dir_new = 0
#Animations
var animations = {
	IDLE = "idle",
	WALK = "walk",
	WALKBACK = "walkBack",
	RUN = "run",
	RUNBACK = "runBack",
	JUMP = "jump_takeOff",
	FALL = "jump_fall",
	LEDGE = "wall_ledge",
	WALLSLIDE = "wall_slide",
	WALLJUMP = "wall_jump",
	FLIGHT = "pack_flight",
	PACKFALL = "pack_fall"
}
#OnReady Variables
onready var wallDetectors: Node2D = $Facing/WallDetectors
onready var wallDetector1: RayCast2D = $Facing/WallDetectors/WallDetector1
onready var wallDetector2: RayCast2D = $Facing/WallDetectors/WallDetector2
onready var ledgeDetector: RayCast2D = $Facing/WallDetectors/LedgeDetector
onready var safeFall: RayCast2D = $Facing/SafeFallDetector
onready var safeSlide: RayCast2D = $Facing/SafeSlideDetector
#Timers
onready var coyoteTimer: Timer = $Timers/CoyoteTimer
#------------------------------------------------------------------------------#
#Applies Facing
func apply_facing():
	if mouse_global.x < self.global_position.x: flip() #Flipped
	elif mouse_global.x > self.global_position.x: unflip() #Unflipped
#Flip
func flip():
	is_flipped = true
	#Torso
	for sprite in facing.get_children():
		if sprite.get_class() == "Sprite": sprite.flip_h = true
	#Detectors
	for detector in wallDetectors.get_children():
		detector.position.x = -3.5
		detector.cast_to.y = -5
	safeSlide.position.x = 3.5
	safeSlide.cast_to.y = 5
#Unflip
func unflip():
	is_flipped = false
	#Torso
	for sprite in facing.get_children():
		if sprite.get_class() == "Sprite": sprite.flip_h = false
	#Detectors
	for detector in wallDetectors.get_children():
		detector.position.x = 3.5
		detector.cast_to.y = 5
	safeSlide.position.x = -3.5
	safeSlide.cast_to.y = -5
#------------------------------------------------------------------------------#
#Player Movement
func handle_movement():
	#Direction
	dir_prev = direction
	direction = (int(Input.is_action_pressed(G.actions.RIGHT)) -
				(int(Input.is_action_pressed(G.actions.LEFT))))
	dir_new = direction
#Apply Movement
func apply_movement():
	#Motion
	motion.x = lerp(motion.x, max_speed * direction, weight())
	motion = move_and_slide(motion, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if Input.is_action_pressed(G.actions.RUN): max_speed = run_speed
	if Input.is_action_just_released(G.actions.RUN): max_speed = walk_speed
	#World Checks
	var was_on_floor = is_grounded
	is_grounded = check_grounded() #Checks for Ground
	found_ledge = check_ledge() #Checks for Ledge
	found_wall = check_wall() #Checks for Wall
	if !is_grounded && was_on_floor: coyoteTimer.start()
#Jump
func jump():
	if !coyoteTimer.is_stopped(): coyoteTimer.stop()
	motion.y = max_yMotion
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
