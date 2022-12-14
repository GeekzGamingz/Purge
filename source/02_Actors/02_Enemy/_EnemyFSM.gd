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
	call_deferred("stateSet", states.idle)
#------------------------------------------------------------------------------#
#Processes
func _process(_delta: float) -> void:
	stateLabel.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#State Logistics
# warning-ignore:unused_argument
func stateLogic(delta):
	pass
#------------------------------------------------------------------------------#
#State Transitions
# warning-ignore:unused_argument
func transitions(delta):
	return null
#------------------------------------------------------------------------------#
#Enter State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateEnter(newState, oldState):
	pass
#Exit State
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func stateExit(oldState, newState):
	pass
