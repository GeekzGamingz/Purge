#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
onready var stateLabel: Label = p.get_node("Outputs/StateOutput")
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	stateAdd("idle")
	stateAdd("walk")
	stateAdd("walkBack")
	stateAdd("run")
	stateAdd("runBack")
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
	if [states.idle, states.walk, states.walkBack,
		states.fall, states.run, states.runBack].has(state) && p.is_grounded:
		#Jumping
		if event.is_action_pressed(G.actions.JUMP):
			if !p.coyoteTimer.is_stopped(): p.coyoteTimer.stop()
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
	p.apply_gravity(delta)
	p.apply_movement()
	p.apply_facing()
	p.apply_aim()
#State Transitions
# warning-ignore:unused_argument
func transitions(delta):
	match(state):
		#Basic Movement
		states.idle: return basicMove()
		states.walk, states.walkBack: return basicMove()
		states.run, states.runBack: return basicMove()
		#Jumping
		states.jump:
			if p.is_grounded: return states.idle
			elif p.motion.y >= 0: return states.fall
		#Falling
		states.fall:
			if p.is_grounded: return states.idle
			elif p.motion.y < 0: return states.jump
	return null
#Enter State
# warning-ignore:unused_argument
func stateEnter(newState, oldState):
	match(newState):
		states.idle: p.playBack.travel(p.animations.IDLE)
		states.walk: p.playBack.travel(p.animations.WALK)
		states.run: p.playBack.travel(p.animations.RUN)
		states.walkBack: p.playBack.travel(p.animations.WALKBACK)
		states.runBack: p.playBack.travel(p.animations.RUNBACK)
		states.jump: p.playBack.start(p.animations.JUMP)
		states.fall: p.playBack.start(p.animations.FALL)
#Exit State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateExit(oldState, newState):
	pass
#------------------------------------------------------------------------------#
#Basic Movement
func basicMove():
	#Idle
	if p.motion.x == 0 && p.is_grounded: return states.idle
	#Verticle Movement
	if !p.is_grounded:
		if p.motion.y < 0: return states.jump
		elif p.motion.y > 0: return states.fall
	#Horizontal Movement
	elif p.motion.x != 0:
		if p.max_speed == p.walk_speed:
			#Flipped
			if p.motion.x > 0 && !p.is_flipped: return states.walk
			elif p.motion.x < 0 && !p.is_flipped: return states.walkBack
			#Unflipped
			if p.motion.x > 0 && p.is_flipped: return states.walkBack
			elif p.motion.x < 0 && p.is_flipped: return states.walk
		elif p.max_speed == p.run_speed:
			#Flipped
			if p.motion.x > 0 && !p.is_flipped: return states.run
			elif p.motion.x < 0 && !p.is_flipped: return states.runBack
			#Unflipped
			if p.motion.x > 0 && p.is_flipped: return states.runBack
			elif p.motion.x < 0 && p.is_flipped: return states.run
