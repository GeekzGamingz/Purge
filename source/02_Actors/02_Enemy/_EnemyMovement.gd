#Inherits Actor Code
extends Actor
class_name EnemyMovement
#------------------------------------------------------------------------------#
#Variables
var direction = 0
var player_POS = Vector2.ZERO
var player_direction = Vector2.ZERO
#Bool Variables
var player_inSight: bool = false
var found_transition: bool = false
#OnReady Variables
#Detectors
onready var wallDetectors = $Facing/WallDetectors
onready var wallDetector = $Facing/WallDetectors/WallDetector
onready var ledgeDetector: RayCast2D = $Facing/WallDetectors/LedgeDetector
#Areas
onready var enemyAreas = $Facing/EnemyAreas
onready var sight = $Facing/EnemyAreas/Sight/CollisionShape2D
onready var projectileOrigin: Position2D = $Facing/EnemyAreas/ProjectileOrigin
#------------------------------------------------------------------------------#
#Processes
func _process(_delta: float) -> void:
	if player_inSight:
		player_direction = (player_POS - self.global_position).normalized()
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
	for detector in wallDetectors.get_children():
		detector.position.x = 10
		detector.cast_to.y = 10
	ledgeDetector.rotation_degrees = -40
	projectileOrigin.position.x = 7
	sight.position.x = 50
#Unflip
func unflip():
	is_flipped = false
	#Torso
	for sprite in facing.get_children():
		if sprite.get_class() == "Sprite": sprite.flip_h = false
	#Detectors
	for detector in wallDetectors.get_children():
		detector.position.x = -10
		detector.cast_to.y = -10
	ledgeDetector.rotation_degrees = 220
	projectileOrigin.position.x = -7
	sight.position.x = -50
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
	if wallDetector.is_colliding(): return true
	return false
#------------------------------------------------------------------------------#
func toggle_transition():
	found_transition = true
	yield(get_tree().create_timer(0.1), "timeout")
	found_transition = false
