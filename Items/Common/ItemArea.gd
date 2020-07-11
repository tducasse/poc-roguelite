extends Area2D

class_name ItemArea

var type = "default item"
var data = null
signal picked()

func get_type():
	return type

func get_data():
	return data
	
func pick():
	emit_signal("picked")
