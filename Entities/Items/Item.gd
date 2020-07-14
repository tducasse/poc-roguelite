extends Node

class_name Item

var type = "Item"
var data = null

signal picked()

func get_type():
	return type

func get_data():
	return data
	
func pick():
	emit_signal("picked")
