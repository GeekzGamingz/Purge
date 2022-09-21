#Inherits KinematicBody2D Code
extends Kinematics
class_name Actor
#------------------------------------------------------------------------------#
#Bool Variables
var is_flipped: bool = false
var is_grounded: bool = false
var found_wall: bool = false
var found_ledge: bool = false
#OnReady Variables
onready var facing: Node2D = $Facing
#Detectors
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
	animTree.active = true
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
