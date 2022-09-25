#Inherits KinObject Code
extends Kinematics
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
export(String, "Direct", "Arc") var projectile_type
#Bool Variables
var colliding: bool = false
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	$SelfDestruct.start()
#------------------------------------------------------------------------------#
#Process
func _process(_delta: float) -> void:
	if colliding:
		get_parent().queue_free()
#Physics Process
func _physics_process(delta: float) -> void:
	motion = move_and_slide(motion)
	match(projectile_type):
		"Direct": pass
		"Arc": apply_gravity(delta)
#------------------------------------------------------------------------------#
#Self Destruct
func _on_SelfDestruct_timeout() -> void:
	colliding = true
func _on_Attack_body_entered(_body: Node) -> void:
#	if body.name != "Player":
	motion = Vector2.ZERO
	$AnimationPlayer.play("impact")
	yield($AnimationPlayer, "animation_finished")
	colliding = true
