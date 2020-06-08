extends KinematicBody2D

const SPEED = 140

# Action Buttons
const UI_RIGHT = "ui_right"
const UI_LEFT = "ui_left"
const UI_UP = "ui_up"
const UI_DOWN = "ui_down"

# Animation parameters
const PLAYBACK_NAME = "parameters/playback"
const IDLE_BLEND_POS = "parameters/Idle/blend_position"
const WALK_BLEND_POS = "parameters/Walk/blend_position"
const IDLE_STATE = "Idle"
const WALK_STATE = "Walk"

# Local vars
var velocity = Vector2.ZERO
var type setget ,get_type


# onready
onready var anim_tree := $AnimationTree
onready var anim_state = anim_tree.get(PLAYBACK_NAME)


func _ready():
	anim_tree.active = true
	# turn right by default
	anim_tree.set(IDLE_BLEND_POS, Vector2(1, 0))
	anim_tree.set(WALK_BLEND_POS, Vector2(1, 0))
	anim_state.travel(IDLE_STATE)


func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength(UI_RIGHT) - Input.get_action_strength(UI_LEFT),
		Input.get_action_strength(UI_DOWN) - Input.get_action_strength(UI_UP)
	).normalized()

	if input_vector != Vector2.ZERO:
		anim_tree.set(IDLE_BLEND_POS, input_vector)
		anim_tree.set(WALK_BLEND_POS, input_vector)
		anim_state.travel(WALK_STATE)
	else:
		anim_state.travel(IDLE_STATE)

	velocity = input_vector * SPEED
	velocity = move_and_slide(velocity)
	

func get_type():
	return "Player"
