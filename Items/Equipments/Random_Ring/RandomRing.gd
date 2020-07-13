extends RandomItem

func _ready():
	type = "Item"
	# item id
	data = {
		'name': "Ring"
	}
	
	generate()
	tooltip.initialize(data.name, specs, rarity)

func _on_RandomRing_picked():
	queue_free()


func _on_Shape_mouse_entered():
	tooltip.show()


func _on_Shape_mouse_exited():
	tooltip.hide()
