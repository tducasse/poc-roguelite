extends KinematicBody2D

# Movements
const ACCELERATION = 500
const MAX_SPEED = 200

# Action Buttons
const UI_RIGHT = "ui_right"
const UI_LEFT = "ui_left"
const UI_UP = "ui_up"
const UI_DOWN = "ui_down"

var velocity = Vector2.ZERO

func _physics_process(delta):
	var inputVector = Vector2(
		Input.get_action_strength(UI_RIGHT) - Input.get_action_strength(UI_LEFT),
		Input.get_action_strength(UI_DOWN) - Input.get_action_strength(UI_UP)
	).normalized()

	velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)
	
	
