#Handles 2D Bodies
extends KinematicBody2D
class_name Actor
#-------------------------------------------------------------------------------------------------#
#Constants
const FLOOR_NORMAL = Vector2.UP
const SLOPE_SLIDE_STOP = 25.0
const FACING_RIGHT = 1
const FACING_LEFT = -1
#-------------------------------------------------------------------------------------------------#
#Variables
#Movement
var motion = Vector2()
var gravity
var walk_speed = 2.5 * Globals.TILE_SIZE
var run_speed = 7 * Globals.TILE_SIZE
var max_speed = walk_speed
var min_jumpMotion
var max_jumpMotion
var min_jumpHeight = 0.5 * Globals.TILE_SIZE
var max_jumpHeight = 2.5 * Globals.TILE_SIZE
var jump_duration = 0.5
var facing = Vector2(FACING_RIGHT, 1)
#-------------------------------------------------------------------------------------------------#
#Set Facing
func set_facing(hor_facing):
	if hor_facing == 0:
		hor_facing = FACING_RIGHT
	var hor_face_mod = hor_facing / abs(hor_facing)
	$Facing.apply_scale(Vector2(hor_face_mod * facing.x, 1))
	facing = Vector2(hor_face_mod, facing.y)
