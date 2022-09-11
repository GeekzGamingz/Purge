extends PlayerMovement
class_name PlayerCombat
#------------------------------------------------------------------------------#
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
