extends Node2D


const SPEED = 140


# Animation parameters
const PLAYBACK_NAME = "parameters/playback"
const IDLE_BLEND_POS = "parameters/Idle/blend_position"
const WALK_BLEND_POS = "parameters/Walk/blend_position"
const IDLE_STATE = "Idle"
const WALK_STATE = "Walk"


# onready
onready var anim_tree := $AnimationTree
onready var anim_state = anim_tree.get(PLAYBACK_NAME)


signal on_move(value)

func enable():
	visible = true
	
	
func disable():
	visible = false
	

func _ready():
	disable()
	anim_tree.active = true
	# turn right by default
	anim_tree.set(IDLE_BLEND_POS, Vector2(1, 0))
	anim_tree.set(WALK_BLEND_POS, Vector2(1, 0))
	anim_state.travel(IDLE_STATE)


func receive_input_vector(input_vector):
	if input_vector != Vector2.ZERO:
		anim_tree.set(IDLE_BLEND_POS, input_vector)
		anim_tree.set(WALK_BLEND_POS, input_vector)
		anim_state.travel(WALK_STATE)
	else:
		anim_state.travel(IDLE_STATE)
		
	if not visible:
	# no need to do anything else if it's not the active character
		return
		
	var velocity = input_vector * SPEED
	emit_signal("on_move", velocity)
