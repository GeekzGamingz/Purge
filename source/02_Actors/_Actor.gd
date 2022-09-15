#Inherits KinematicBody2D Code
extends KinematicBody2D
class_name Actor
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
#Bool Variables
var is_flipped: bool = false
var is_grounded: bool = false
var found_wall: bool = false
var found_ledge: bool = false
#OnReady Variables
onready var facing: Node2D = $Facing
#Detectors
onready var wallDetectors: Node2D = $Facing/WallDetectors
onready var wallDetector1: RayCast2D = $Facing/WallDetectors/WallDetector1
onready var wallDetector2: RayCast2D = $Facing/WallDetectors/WallDetector2
onready var ledgeDetector: RayCast2D = $Facing/WallDetectors/LedgeDetector
onready var groundDetectors: Node2D = $Facing/GroundDetectors
#Animation Nodes
onready var spritePlayer: AnimationPlayer = $AnimationPlayers/SpritePlayer
onready var fxPlayer: AnimationPlayer = $AnimationPlayers/EffectsPlayer
onready var animTree: AnimationTree = $AnimationPlayers/AnimationTree
onready var playBack = animTree.get("parameters/playback")
onready var current_state = playBack.get_current_node()
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	gravity = 2 * max_jumpHeight / pow(jump_duration, 2)
	min_jumpMotion = -sqrt(2 * gravity * min_jumpHeight)
	max_jumpMotion = -sqrt(2 * gravity * max_jumpHeight)
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
