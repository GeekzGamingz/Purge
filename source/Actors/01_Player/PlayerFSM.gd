#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
onready var stateLabel: Label = p.get_node("StateOutput")
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	stateAdd("idle")
	stateAdd("walk")
	stateAdd("run")
	stateAdd("jump")
	stateAdd("fall")
	call_deferred("stateSet", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	stateLabel.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#Input Handler
func _input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.run,
		states.fall].has(state) && !p.is_jumping:
		#Jumping
		if event.is_action_pressed(G.actions.JUMP):
			if p.is_grounded || !p.coyoteTimer.is_stopped():
				p.coyoteTimer.stop()
			p.motion.y = p.max_jumpMotion
	if [states.jump].has(state):
	#Jump Interrupt
		if (event.is_action_released(G.actions.JUMP) &&
			p.motion.y < p.min_jumpMotion):
			p.motion.y = p.min_jumpMotion
#------------------------------------------------------------------------------#
#State Machine
#State Logistics
func stateLogic(delta):
	p.moveDirection()
	p.handle_movement()
	p.apply_gravity(delta)
	p.apply_movement()
#State Transitions
func basicMove():
	if p.motion.x == 0: return states.idle
	if !p.is_grounded:
		if p.motion.y < 0: return states.jump
		elif p.motion.y > 0: return states.fall
	elif p.motion.x != 0:
		if p.max_speed == p.walk_speed: return states.walk
		elif p.max_speed == p.run_speed: return states.run
# warning-ignore:unused_argument
func transitions(delta):
	match(state):
		#Basic Movement
		states.idle, states.walk, states.run: return basicMove()
		#Jumping
		states.jump:
			p.is_jumping = true
			if p.is_grounded: return states.idle
			elif p.motion.y >= 0: return states.fall
		#Falling
		states.fall:
			p.is_jumping = true if p.coyoteTimer.is_stopped() else false
			if p.is_grounded: return states.idle
			elif p.motion.y < 0: return states.jump
	return null
#Enter State
# warning-ignore:unused_argument
func stateEnter(newState, oldState):
	match(newState):
		states.idle: p.playBack.travel("idle")
		states.walk: p.playBack.travel("walk")
		states.run: p.playBack.travel("run")
		states.jump: p.playBack.start("jump_takeOff")
		states.fall: p.playBack.start("jump_fall")
#Exit State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateExit(oldState, newState):
	pass
#------------------------------------------------------------------------------#
#Assign Animations
func assign_animation():
	p.animTree["parameters/conditions/Idle"] = states.idle
	p.animTree["parameters/conditions/Walking"] = states.walk
	p.animTree["parameters/conditions/Running"] = states.run
	p.animTree["parameters/conditions/Jumping"] = states.jump
	p.animTree["parameters/conditions/Falling"] = states.fall
