extends Item

func _ready():
	type = "Item"
	# item id
	data = {
		'name': "Ring"
	}


func _on_Ring_picked():
	queue_free()
