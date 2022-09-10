#Inherits StateMachine Code
extends StateMachine
#-------------------------------------------------------------------------------------------------#
#Variables
#OnReady Variables
onready var stateLabel: Label = parent.get_node("StateOutput")
#-------------------------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	stateAdd("idle")
	stateAdd("walk")
	stateAdd("run")
	stateAdd("jump")
	stateAdd("fall")
	call_deferred("stateSet", states.idle)
#-------------------------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	stateLabel.text = str(states.keys()[state])
#-------------------------------------------------------------------------------------------------#
#Input Handler
func _input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.run,
		states.fall].has(state) && !parent.jumping:
		#Jumping
		if event.is_action_pressed("action_jump"):
			if parent.grounded || !parent.coyoteTimer.is_stopped():
				parent.coyoteTimer.stop()
			parent.motion.y = parent.max_jumpMotion
	if [states.jump].has(state):
	#Jump Interrupt
		if event.is_action_released("action_jump") && parent.motion.y < parent.min_jumpMotion:
			parent.motion.y = parent.min_jumpMotion
#-------------------------------------------------------------------------------------------------#
#State Machine
#State Logistics
func stateLogic(delta):
	parent.moveDirection()
	parent.handle_movement()
	parent.apply_gravity(delta)
	parent.apply_movement()
#State Transitions
# warning-ignore:unused_argument
func transitions(delta):
	match(state):
		#Idle
		states.idle:
			if !parent.grounded:
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			elif parent.motion.x != 0:
				if parent.max_speed == parent.walk_speed:
					return states.walk
				elif parent.max_speed == parent.run_speed:
					return states.run
		#Walking
		states.walk, states.run:
			if !parent.grounded:
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			if parent.motion.x == 0:
				return states.idle
			elif parent.max_speed == parent.walk_speed:
				return states.walk
			elif parent.max_speed == parent.run_speed:
				return states.run
		#Jumping
		states.jump:
			parent.jumping = true
			if parent.grounded:
				return states.idle
			elif parent.motion.y >= 0:
				return states.fall
		#Falling
		states.fall:
			parent.jumping = true if parent.coyoteTimer.is_stopped() else false
			if parent.grounded:
				return states.idle
			elif parent.motion.y < 0:
				return states.jump
	return null
#Enter State
# warning-ignore:unused_argument
func stateEnter(newState, oldState):
	match(newState):
		states.idle: parent.playBack.travel("idle")
		states.walk: parent.playBack.travel("walk")
		states.run: parent.playBack.travel("run")
		states.jump: parent.playBack.start("jump_takeOff")
		states.fall: parent.playBack.start("jump_fall")
#Exit State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateExit(oldState, newState):
	pass
#-------------------------------------------------------------------------------------------------#
#Assign Animations
func assign_animation():
	parent.animTree["parameters/conditions/Idle"] = states.idle
	parent.animTree["parameters/conditions/Walking"] = states.walk
	parent.animTree["parameters/conditions/Running"] = states.run
	parent.animTree["parameters/conditions/Jumping"] = states.jump
	parent.animTree["parameters/conditions/Falling"] = states.fall
