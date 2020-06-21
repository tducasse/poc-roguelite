extends Node2D

const SPEED = 140


# Animation parameters
const PLAYBACK_NAME = "parameters/playback"
const DEFAULT_BLEND_POS = "parameters/Default/blend_position"
const DEFAULT_STATE = "Default"


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
	anim_tree.set(DEFAULT_BLEND_POS, Vector2(1, 0))
	anim_state.travel(DEFAULT_STATE)


func receive_input_vector(input_vector):
	if input_vector != Vector2.ZERO:
		anim_tree.set(DEFAULT_BLEND_POS, input_vector)
		
	if not visible:
	# no need to do anything else if it's not the active character
		return
	anim_state.travel(DEFAULT_STATE)
		
	var velocity = input_vector * SPEED
	emit_signal("on_move", velocity)

