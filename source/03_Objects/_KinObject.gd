#Inherits KinematicBody2D Code
extends KinematicBody2D
class_name KinObject
#------------------------------------------------------------------------------#
#Constants
const FLOOR_NORMAL = Vector2.UP
const SLOPE_SLIDE_STOP = 25.0
#------------------------------------------------------------------------------#
#Variables
var mouse_global = Vector2.ZERO
var mouse_local = Vector2.ZERO
var mouse_direction = Vector2.ZERO
#Movement
var motion = Vector2.ZERO
var gravity
var walk_speed = 2.5 * G.TILE_SIZE
var run_speed = 7 * G.TILE_SIZE
var max_speed = walk_speed
var min_jumpMotion
var max_jumpMotion
var min_jumpHeight = 0.5 * G.TILE_SIZE
var max_jumpHeight = 2.5 * G.TILE_SIZE
var jump_duration = 0.5
