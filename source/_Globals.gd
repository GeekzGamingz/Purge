#Inherits Node Code
extends Node
#------------------------------------------------------------------------------#
#Constants
const TILE_SIZE = 24
#Variables
var actions = {
	ACCEPT = "ui_accept",
	PAUSE = "ui_cancel",
	MENU = "ui_select",
	NEXT = "ui_focus_next",
	PREV = "ui_focus_prev",
	LEFT = "ui_left",
	RIGHT = "ui_right",
	UP = "ui_up",
	DOWN = "ui_down",
	RUN = "ui_run",
	JUMP = "ui_jump",
	SHOOT = "ui_primary_attack"
}
#OnReady Variables
onready var PLAYER = get_tree().get_root().get_node(
	"World/YSort/WorldKinematics/Player")
