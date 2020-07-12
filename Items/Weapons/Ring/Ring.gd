extends Item

func _ready():
	type = "Item"
	# item id
	data = 1
	

func _on_Ring_picked():
	queue_free()
