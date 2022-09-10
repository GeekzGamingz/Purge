extends Node
#-------------------------------------------------------------------------------------------------#
#Constants
const TILE_SIZE = 24
#-------------------------------------------------------------------------------------------------#
#Signals
signal shells_update
signal napalm_update
signal score_update
signal score_reset
#-------------------------------------------------------------------------------------------------#
#Variables
var shells: = 0
var napalm: = 0
var score: = 0 setget set_score
#-------------------------------------------------------------------------------------------------#
#Setters
#Update Shotgun Shells
func set_shells(value: int) -> void:
	shells = value
	emit_signal("shells_update")
#Add/Subtract Shells
func change_shells(value: int) -> void:
	shells = shells + value
	emit_signal("shells_update")
#Update Napalm
func set_napalm(value: int) -> void:
	napalm = value
	emit_signal("napalm_update")
#Add/Subtract Napalm
func change_napalm(value: int) -> void:
	napalm = napalm + value
	emit_signal("napalm_update")
#Add/Subtract Score
func set_score(value: int) -> void:
	score = score + value
	emit_signal("score_update")
#Reset Score
func reset_score(value: int) -> void:
	score = value
	emit_signal("score_reset")
