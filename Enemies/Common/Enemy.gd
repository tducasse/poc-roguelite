extends KinematicBody2D

class_name Enemy

enum states {
	IDLE,
	WANDER,
	CHASE,
	LOOT
}

# "Constants" children have to initialize
var FRICTION = 200
var KNOCKBACK = 125
var ACCELERATION = 500
var MAX_SPEED = 50
var OVERLAPPING_AREA = 400
var WANDER_TARGET_APPROXIMATION = 3
var SOFT_COLLISION: Area2D
var DETECTION_ZONE: Area2D
var DROP_ZONE: CollisionShape2D
var SPRITE: AnimatedSprite
var DROP_TABLE = {}
var WANDER_CONTROLLER: Node2D

var state = states.IDLE
var knockbackVelocity = Vector2.ZERO
var velocity = Vector2.ZERO


func _physics_process(delta):
	knockbackVelocity = knockbackVelocity.move_toward(Vector2.ZERO, FRICTION * delta)
	knockbackVelocity = move_and_slide(knockbackVelocity)
	
	match state:
		states.IDLE:
			idle_state(delta)
		states.WANDER:
			wander_state(delta)
		states.CHASE:
			chase_state(delta)
		states.LOOT:
			loot_state(delta)

	if SOFT_COLLISION.is_colliding():
		velocity += SOFT_COLLISION.get_push_vector() * delta * OVERLAPPING_AREA
	velocity = move_and_slide(velocity)


func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	chase_on_sight()
	wander_or_idle()

func wander_state(delta):
	chase_on_sight()
	wander_or_idle()
	move_toward_position(WANDER_CONTROLLER.targetPosition, delta)
	
	if global_position.distance_to(WANDER_CONTROLLER.targetPosition) <= WANDER_TARGET_APPROXIMATION:
		state = get_random_state([states.IDLE, states.WANDER])
		WANDER_CONTROLLER.start_timer()


func chase_state(delta):
	if DETECTION_ZONE.is_player_on_sight():
		var player = DETECTION_ZONE.player
		move_toward_position(player.global_position, delta)
	else:
		state = states.IDLE


func loot_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func wander_or_idle():
	if WANDER_CONTROLLER.get_time_left() == 0:
		state = get_random_state([states.IDLE, states.WANDER])
		WANDER_CONTROLLER.start_timer()


func get_random_state(statesList):
	statesList.shuffle()
	return statesList.pop_front()


func chase_on_sight():
	if DETECTION_ZONE.is_player_on_sight() || DETECTION_ZONE.are_items_on_sight():
		state = states.CHASE


func move_toward_position(targetPos, delta):
	var direction = position.direction_to(targetPos)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	SPRITE.flip_h = velocity.x < 0


func drop_items():
	var chance = randi() % 100

	for item in DROP_TABLE.keys():
		if chance < DROP_TABLE.get(item):
			var itemInstance: Area2D = item.instance()
			get_parent().add_child(itemInstance)
			itemInstance.position = get_random_position_in_drop_zone()

	drop_looter_callback()

func get_random_position_in_drop_zone():
	return Vector2(
				rand_range(position.x - DROP_ZONE.shape.radius, position.x + DROP_ZONE.shape.radius),
				rand_range(position.y - DROP_ZONE.shape.radius, position.y + DROP_ZONE.shape.radius)
			)

# Methods to override by looter children
func drop_looter_callback():
	pass
