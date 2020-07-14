extends Enemy

const RING = preload("res://Entities/Items/Equipments/Random_Ring/RandomRing.tscn")

var lootedDrop = []
onready var stats = $Stats
onready var looterTimer = $LooterTimer


func _ready():
	DROP_TABLE = {RING: 50}
	SOFT_COLLISION = $SoftCollision
	DETECTION_ZONE = $DetectionZone
	DROP_ZONE = $DropZone/CollisionShape2D
	SPRITE = $AnimatedSprite
	WANDER_CONTROLLER = $WanderController
	NAVIGATION_NODE = get_node(NAVIGATION_PATH)


# Override
func chase_state(delta):
	if DETECTION_ZONE.are_items_on_sight():
		var item = DETECTION_ZONE.items[0]
		move_toward_position(item.global_position, delta)
	elif DETECTION_ZONE.is_player_on_sight():
		var player = DETECTION_ZONE.player
		var path = NAVIGATION_NODE.get_simple_path(global_position, player.global_position, true)
		move_along_path(path, delta)
	else:
		state = states.IDLE


# Override
func drop_looter_callback():
	for item in lootedDrop:
		var item_instance = item.instance()
		item_instance.position = get_random_free_position_in_drop_zone(item_instance)
		get_parent().add_child(item_instance)
		
	lootedDrop = []


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage

func drop_and_die():
	drop_items()
	queue_free()

func _on_Stats_no_health():
	# We call drop_items, which tries to add a child that contains an Area.
	# Since the current function is called as a result of processing the area
	# collisions, adding an area is forbidden via a mutex (endless loop).
	# Using call_deferred tells the engine to call the function once we're idle.
	call_deferred("drop_and_die")


func _on_Hitbox_area_entered(area: Area2D):
	var owner = area.get_parent()
	if owner.has_method("get_type") && owner.type == "Item":
		var itemScene = load(owner.filename)
		lootedDrop.append(itemScene)
		owner.queue_free()
		state = states.LOOT
		looterTimer.start()


func _on_LooterTimer_timeout():
	state = states.IDLE
