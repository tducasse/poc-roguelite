extends Node2D


func _on_WarpLab_body_entered(body):
	if body.name == "Player":
		Loader.goto_scene("res://Scenes/Lab/Lab_0/Lab_0.tscn", "SpawnPosLab")
