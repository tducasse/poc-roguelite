extends "res://Enemies/Common/Enemy.gd"


const RING = preload("res://Items/Weapons/Ring/Ring.tscn")

var lootedDrop = []
onready var stats = $Stats

func _ready():
	DROP_TABLE = {RING: 50}
	SOFT_COLLISION = $SoftCollision
	DETECTION_ZONE = $DetectionZone
	DROP_ZONE = $DropZone/CollisionShape2D
	SPRITE = $AnimatedSprite

# Override
func chase_state(delta):
	if DETECTION_ZONE.are_items_on_sight():
		var item = DETECTION_ZONE.items[0]
		move_toward_position(item.global_position, delta)
	elif DETECTION_ZONE.is_player_on_sight():
		var player = DETECTION_ZONE.player
		move_toward_position(player.global_position, delta)
	else:
		state = states.IDLE

# Override
func looter_callback():
	for item in lootedDrop:
		var itemInstance = item.instance()
		get_parent().add_child(itemInstance)
		itemInstance.position = get_random_position_in_drop_zone()
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
	if area.has_method("get_type") && area.type == "Item":
		var itemScene = load(area.filename)
		lootedDrop.append(itemScene)
		area.queue_free()
