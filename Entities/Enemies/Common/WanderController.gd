extends Node2D


const WANDER_RANGE = 64
const MIN_WANDER_TIME = 1
const MAX_WANDER_TIME = 3

onready var referencePosition = global_position
onready var targetPosition = update_target_position()
onready var timer = $Timer


func update_target_position():
	var targetVector = Vector2(rand_range(-WANDER_RANGE, WANDER_RANGE), rand_range(-WANDER_RANGE, WANDER_RANGE))
	targetPosition = referencePosition + targetVector


func get_time_left():
	return timer.time_left
	

func start_timer():
	timer.start(rand_range(MIN_WANDER_TIME, MAX_WANDER_TIME))


func _on_Timer_timeout():
	update_target_position()
