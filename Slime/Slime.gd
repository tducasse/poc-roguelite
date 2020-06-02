extends KinematicBody2D


const RING = preload("res://Items/Weapons/Ring/Ring.tscn")
var dropTable = {RING: 50}


onready var stats = $Stats


func drop_items():
	var chance = randi() % 100

	for item in dropTable.keys():
		if chance < dropTable.get(item):
			var itemInstance = item.instance()
			get_parent().add_child(itemInstance)
			itemInstance.position = position

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage

func drop_and_die():
	drop_items()
	queue_free()

func _on_Stats_no_health():
	# We call drop_items, which tries to add a child that contains an Area.
	# Since the current function is called as as a result of processing the area
	# collisions, adding an area is forbidden via a mutex (endless loop).
	# Using call_deferred tells the engine to call the function once we're idle.
	call_deferred("drop_and_die")
