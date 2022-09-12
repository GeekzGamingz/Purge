#Inherits PlayerCombat Code
extends PlayerWeapons
class_name PlayerCombat
#------------------------------------------------------------------------------#
#Variables
var projectile_scene
#Exported Variables
export var projectile_speed = 1750
#OnReady Variables
onready var muzzlePlayer: AnimationPlayer = $AnimationPlayers/MuzzlePlayer
onready var boomshotTimer: Timer = $Timers/BoomshotTimer

#Preloaded Scenes
var bolt_scene = preload(
	"res://source/03_Objects/01_Projectiles/01_Bolt/Bolt.tscn")
var slug_scene = preload(
	"res://source/03_Objects/01_Projectiles/02_Slug/ScatterShot.tscn")
#------------------------------------------------------------------------------#
#Aim
func apply_aim():
	#Shoulder Flipped
	if is_flipped:
		shoulder.position = Vector2(2, -4)
		for sprite in shoulder.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_v = true
				sprite.position = Vector2(1, -4)
	#Shoulder Unflipped
	if !is_flipped:
		shoulder.position = Vector2(-2, -4)
		for sprite in shoulder.get_children():
			if sprite.get_class() == "Sprite":
				sprite.flip_v = false
				sprite.position = Vector2(1, 4)
	#Rotation
	shoulder.look_at(mouse_global)
	apply_shoot()
#------------------------------------------------------------------------------#
#Shoot
func apply_shoot():
	#Represser
	if Input.is_action_pressed(G.actions.SHOOT):
		sprite_mz.visible = true #Show Flash
		match(current_weapon):
			"REPRESSER":
				if weaponTimer.is_stopped():
					weaponTimer.start()
					muzzlePlayer.play("represser") #Muzzle Flash
					projectile_scene = bolt_scene
					spawn_projectile()
			"BOOMSHOT":
				if boomshotTimer.is_stopped():
					boomshotTimer.start()
					muzzlePlayer.play("boomshot") #Muzzle Flash
					projectile_scene = slug_scene
					spawn_projectile()
			"SWEEPER": pass
	if Input.is_action_just_released(G.actions.SHOOT):
		sprite_mz.visible = false #Hide Flash
		match(current_weapon):
			"REPRESSER": pass
#Spawn Projectile
func spawn_projectile():
	var projectile = projectile_scene.instance() #Sets Ammo
	var projectile_pos = sprite_arms.global_position #Sets PoS
	projectile.position = projectile_pos
	projectile.rotation = atan2(mouse_direction.y, mouse_direction.x)
	get_tree().get_root().add_child(projectile)
	for i in projectile.get_children():
		i.motion = (mouse_direction * projectile_speed).rotated(i.rotation)
