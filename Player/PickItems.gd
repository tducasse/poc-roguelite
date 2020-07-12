extends Area2D

signal pick_item(type, data)

func _on_PickItems_area_entered(area : Item):
	emit_signal("pick_item", area.get_type(), area.get_data())
	area.pick()
