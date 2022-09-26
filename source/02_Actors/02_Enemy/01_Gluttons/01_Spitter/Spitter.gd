#Inherits EnemyCombat Code
extends EnemyCombat
#------------------------------------------------------------------------------#
#Variables
#Dictionaries
var animations = {
	IDLE = "idle",
	PTUI = "attack",
	HIDE = "hide",
	PEEK = "peek",
	BURROWED = "burrowed",
	AMBUSH = "ambush"
}
#Preloaded Scenes
var loogie_scene = preload( #Lougie Scene
	"res://source/03_Objects/01_Projectiles/04_Loogie/Loogie.tscn")
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	projectile_scene = loogie_scene
