#Inherits KinematicBody2D Code
extends KinematicBody2D
class_name Kinematics
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
var min_yMotion
var max_yMotion
var min_yHeight = 0.5 * G.TILE_SIZE
var max_yHeight = 2.5 * G.TILE_SIZE
var air_duration = 0.5
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	gravity = 2 * max_yHeight / pow(air_duration, 2)
	min_yMotion = -sqrt(2 * gravity * min_yHeight)
	max_yMotion = -sqrt(2 * gravity * max_yHeight)
#------------------------------------------------------------------------------#
#Actor Processes
func _process(_delta: float) -> void:
	#Mouse Detection
	mouse_global = get_global_mouse_position()
	mouse_local = get_local_mouse_position()
	mouse_direction = (mouse_global - self.global_position).normalized()
#------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta):
	motion.y += gravity * delta
