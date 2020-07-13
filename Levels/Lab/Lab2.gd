extends Node2D


func _on_WarpLab_body_entered(body):
	if body.name == "Player":
		Loader.goto_scene("res://Levels/Lab/Lab.tscn", "SpawnPosLab")
