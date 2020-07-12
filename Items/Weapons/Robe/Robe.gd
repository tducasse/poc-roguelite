extends Item

func _ready():
	type = "Character"
	# character index
	data = {
		'index': 1
	}
	

func _on_Robe_picked():
	queue_free()
