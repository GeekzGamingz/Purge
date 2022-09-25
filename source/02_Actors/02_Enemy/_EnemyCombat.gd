#Inherits EnemyMovement Code
extends EnemyMovement
class_name SpitterCombat
#------------------------------------------------------------------------------#
#Variables
var projectile_scene
#Exported Variables
export var projectile_speed = 500
export(String, "Direct", "Arc") var projectile_type
#Bool Variables
var reset: bool = false
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
#OnReady Variables
onready var stateTimer: Timer = $Timers/StateTimer
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	projectile_scene = loogie_scene
#------------------------------------------------------------------------------#
#Area Detection
#Body Entered
func _on_Sight_body_entered(body):
	if body.name == "Player":
		player_inSight = true
		player_POS = body.global_position
#Body Exited
func _on_Sight_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inSight = false
		player_POS = body.global_position
#------------------------------------------------------------------------------#
#Spawn Projectile
func spawn_projectile():
	var projectile = projectile_scene.instance() #Sets Ammo
	var projectile_pos = projectileOrigin.global_position #Sets PoS
	projectile.position = projectile_pos
	projectile.rotation = atan2(-player_direction.y, -player_direction.x)
	get_tree().get_root().add_child(projectile)
	for i in projectile.get_children():
		match(projectile_type):
			"Direct":
				i.projectile_type = "Direct" #Sets Instanced Projectile Type
				i.motion = ( #Direct Shot Toward the Player
				player_direction * projectile_speed).rotated(i.rotation)
			"Arc":
				i.projectile_type = "Arc" #Sets Instanced Projectile Type
				var arc_height = player_POS.y - global_position.y - 12
				i.motion = ( #Arc Shot Toward the Player
				apply_arc(global_position, player_POS, arc_height))
