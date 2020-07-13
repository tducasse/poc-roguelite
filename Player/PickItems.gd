extends Area2D

signal pick_item(type, data)


func _on_PickItems_area_entered(area):
	var item = area.get_parent()
	emit_signal("pick_item", item.get_type(), item.get_data())
	item.pick()
