#Inherits Actor Code
extends Actor
class_name EnemyMovement
#------------------------------------------------------------------------------#
#Variables
var direction = 0
#OnReady Variables
onready var ledgeDetector: RayCast2D = $Facing/LedgeDetector
#------------------------------------------------------------------------------#
#Applies Facing
func apply_facing():
	if found_wall:
		if !is_flipped: flip() #Flipped
		else: unflip() #Unflipped
#Flip
func flip():
	is_flipped = true
	#Torso
	for sprite in facing.get_children():
		if sprite.get_class() == "Sprite": sprite.flip_h = true
	#Detectors
	ledgeDetector.position.x = 5.5
	ledgeDetector.cast_to.y = 5
	ledgeDetector.rotation_degrees = -40
#Unflip
func unflip():
	is_flipped = false
	#Torso
	for sprite in facing.get_children():
		if sprite.get_class() == "Sprite": sprite.flip_h = false
	#Detectors
	ledgeDetector.position.x = -5.5
	ledgeDetector.cast_to.y = -5
	ledgeDetector.rotation_degrees = 220
#------------------------------------------------------------------------------#
func apply_movement():
	#Direction
	direction = 1 if is_flipped else -1
	#Motion
	motion.x = lerp(motion.x, max_speed * direction, weight())
	motion = move_and_slide(motion, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	#World Checks
	is_grounded = check_grounded() #Checks for Ground
	found_wall = check_wall() #Checks for Wall
#------------------------------------------------------------------------------#
#Enemy Weight
func weight():
	#Ground Weight
	if is_grounded:
		#Running
		if motion.x != 0 && max_speed == run_speed: return 0.05
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
	if !ledgeDetector.is_colliding(): return true
	if is_on_wall(): return true
	return false
