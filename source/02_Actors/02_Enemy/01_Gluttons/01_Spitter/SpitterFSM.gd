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
	stateAdd("ptui")
	stateAdd("hide")
	stateAdd("burrowed")
	stateAdd("peek")
	call_deferred("stateSet", states.idle)
#------------------------------------------------------------------------------#
#Processes
func _process(_delta: float) -> void:
	stateLabel.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#State Logistics
# warning-ignore:unused_argument
func stateLogic(delta):
	match(state):
		states.idle: p.apply_movement()
	p.apply_gravity(delta)
	p.apply_facing()
#------------------------------------------------------------------------------#
#State Transitions
# warning-ignore:unused_argument
func transitions(delta):
	match(state):
		states.idle: if p.player_inSight: return states.ptui
		states.ptui: return states.hide
		states.hide, states.peek: return randomState()
		states.burrowed: if p.stateTimer.is_stopped(): return states.peek
#------------------------------------------------------------------------------#
#Enter State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateEnter(newState, oldState):
	match(state):
		states.idle: p.playBack.travel(p.animations.IDLE)
		states.ptui: p.playBack.travel(p.animations.PTUI)
		states.hide: p.stateTimer.start()
		states.peek: 
			p.stateTimer.stop()
			p.playBack.travel(p.animations.PEEK)
		states.burrowed: 
			p.playBack.travel(p.animations.BURROWED)
			p.stateTimer.start()
#Exit State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateExit(oldState, newState):
	pass
#------------------------------------------------------------------------------#
func randomState():
	if p.stateTimer.is_stopped():
		p.stateTimer.start()
		randomize()
		var rstate = (randi() % 5)
		match(rstate):
			0: return states.idle
			1, 2: return states.burrowed
			3: return states.peek
			4: return states.ptui
