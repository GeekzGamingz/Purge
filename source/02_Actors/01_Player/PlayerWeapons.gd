#Inherits PlayerMovement Code
extends PlayerMovement
class_name PlayerWeapons
#------------------------------------------------------------------------------#
#Variables
var weapon_select = 0
var carried_weapons = 2
#Exported Variables
export(String, "REPRESSER", "BOOMSHOT", "SWEEPER") var current_weapon
#OnReady Variables
#Sprites
onready var shoulder: Node2D = $Facing/Shoulder
onready var sprite_arms: Sprite = $Facing/Shoulder/Sprite_Arms
onready var sprite_mz: Sprite = $Facing/Shoulder/Sprite_Arms/Sprite_MzFlash
onready var sprite_repressor: Sprite = $Facing/Shoulder/Sprite_Repressor
onready var sprite_boomshot: Sprite = $Facing/Shoulder/Sprite_Boomshot
onready var sprite_sweeper: Sprite = $Facing/Shoulder/Sprite_Sweeper
#Timers
onready var weaponTimer: Timer = $Timers/WeaponTimer
#------------------------------------------------------------------------------#
#Weapon Selector
func apply_weapon(event):
	if weaponTimer.is_stopped(): #Wait to Switch Again
		if event.is_action_pressed(G.actions.NEXT):
			weaponTimer.start()
			weapon_select += 1
			if weapon_select > carried_weapons: weapon_select = 0
			check_weapon()
		elif event.is_action_pressed(G.actions.PREV):
			weaponTimer.start()
			weapon_select -= 1
			if weapon_select < 0: weapon_select = carried_weapons
			check_weapon()
#Weapon Checker
func check_weapon():
	match(weapon_select):
		#Full Repressor
		0:
			current_weapon = "REPRESSER"
			for sprite in shoulder.get_children():
				if sprite.get_class() == "Sprite": sprite.visible = false
			sprite_repressor.visible = true
		#Boomshot Pistol
		1:
			current_weapon = "BOOMSHOT"
			for sprite in shoulder.get_children():
				if sprite.get_class() == "Sprite": sprite.visible = false
			sprite_boomshot.visible = true
		#Flame Sweeper
		2:
			current_weapon = "SWEEPER"
			for sprite in shoulder.get_children():
				if sprite.get_class() == "Sprite": sprite.visible = false
			sprite_sweeper.visible = true
	sprite_arms.visible = true
	sprite_mz.visible = false
#------------------------------------------------------------------------------#
