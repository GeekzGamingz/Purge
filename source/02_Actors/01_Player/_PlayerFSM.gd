#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
onready var stateLabel: Label = p.get_node("Outputs/StateOutput")
onready var weaponLabel: Label = p.get_node("Outputs/WeaponOutput")
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
	stateAdd("ledge")
	stateAdd("wallSlide")
	call_deferred("stateSet", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	stateLabel.text = str(states.keys()[state])
	weaponLabel.text = p.current_weapon
#------------------------------------------------------------------------------#
#Input Handler
func _input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.walkBack,
		states.fall, states.run, states.runBack].has(state) && p.is_grounded:
		#Jumping
		if event.is_action_pressed(G.actions.JUMP): p.jump()
	match(state):
		states.jump:
			#Jump Interrupt
			if (event.is_action_released(G.actions.JUMP) &&
				p.motion.y < p.min_jumpMotion):
				p.motion.y = p.min_jumpMotion
	#Switch Weapons
	p.apply_weapon(event)
#------------------------------------------------------------------------------#
#State Machine
#State Logistics
func stateLogic(delta):
	if ![states.ledge, states.wallSlide].has(state):
		p.handle_movement() #No Control in Listed States
		p.apply_facing() #No Facing in Listed States
		p.apply_gravity(delta) #No Gravity in Listed States
	p.apply_movement()
	p.apply_aim()
	match(state): #Conditional States
		states.ledge: p.motion = Vector2.ZERO
		states.wallSlide: 
			p.apply_gravity(delta)
			p.motion.y *= 0.75
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
			elif p.found_ledge: return states.ledge
			elif p.found_wall: return states.wallSlide
		#Walls
		states.ledge, states.wallSlide:
			if !p.safeSlide.is_colliding(): return states.fall
			if (Input.is_action_just_pressed(G.actions.DOWN) ||
				p.safeFall.is_colliding()):
				return states.fall
			if Input.is_action_just_pressed(G.actions.JUMP):
				p.jump()
				return states.jump
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
		states.fall: p.playBack.start(p.animations.FALL)
		states.jump:
			if p.found_wall: p.playBack.start(p.animations.JUMP)
			else: p.playBack.start(p.animations.WALLJUMP)
		states.ledge: #warning-ignore:standalone_ternary
			p.flip() if !p.is_flipped else p.unflip()
			p.playBack.start(p.animations.LEDGE)
		states.wallSlide: #warning-ignore:standalone_ternary
			p.flip() if !p.is_flipped else p.unflip()
			p.playBack.start(p.animations.WALLSLIDE)
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
	if !p.is_grounded: #When Airbourne
		if p.motion.y < 0: return states.jump
		elif p.motion.y > 0: return states.fall
	#Horizontal Movement
	elif p.motion.x != 0:
		if p.max_speed == p.walk_speed: #When Walking
			#Flipped
			if p.motion.x > 0 && !p.is_flipped: return states.walk
			elif p.motion.x < 0 && !p.is_flipped: return states.walkBack
			#Unflipped
			if p.motion.x > 0 && p.is_flipped: return states.walkBack
			elif p.motion.x < 0 && p.is_flipped: return states.walk
		elif p.max_speed == p.run_speed: #When Running
			#Flipped
			if p.motion.x > 0 && !p.is_flipped: return states.run
			elif p.motion.x < 0 && !p.is_flipped: return states.runBack
			#Unflipped
			if p.motion.x > 0 && p.is_flipped: return states.runBack
			elif p.motion.x < 0 && p.is_flipped: return states.run
