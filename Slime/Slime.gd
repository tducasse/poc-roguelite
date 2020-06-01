extends KinematicBody2D


const LASER_SWORD = preload("res://Items/Weapons/LaserSword/LaserSword.tscn")
var dropTable = {LASER_SWORD: 50}


onready var stats = $Stats


func drop_items():
	var chance = randi() % 100

	for item in dropTable.keys():
		if dropTable.get(item) < chance:
			var itemInstance = item.instance()
			get_parent().add_child(itemInstance)
			itemInstance.position = position

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage


func _on_Stats_no_health():
	drop_items()
	queue_free()
