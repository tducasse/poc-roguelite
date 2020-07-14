extends Node2D


func _on_WarpLab2_body_entered(body):
	if body.name == "Player":
		Loader.goto_scene("res://Scenes/Lab/Lab_1/Lab_1.tscn", "SpawnPosLab2")
