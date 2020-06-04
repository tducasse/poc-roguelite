extends Area2D


var player = null
var items = []

func is_player_on_sight():
	return player != null


func are_items_on_sight():
	return items.size() > 0


func _on_DetectionZone_body_entered(body):
	if body.has_method("get_type") && body.type == "Player":
		player = body


func _on_DetectionZone_body_exited(body):
	if body.has_method("get_type") && body.type == "Player":
		player = null


func _on_DetectionZone_area_entered(area):
	if area.has_method("get_type") && area.type == "Item":
		items.append(area)


func _on_DetectionZone_area_exited(area):
	if area.has_method("get_type") && area.type == "Item":
		items.erase(area)
