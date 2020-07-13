extends Node2D


func _on_WarpLab2_body_entered(body):
	if body.name == "Player":
		Loader.goto_scene("res://Levels/Lab/Lab2.tscn", "SpawnPosLab2")
