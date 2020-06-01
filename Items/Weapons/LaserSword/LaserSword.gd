extends "res://Items/Item.gd"


onready var animationPlayer := $AnimationPlayer
onready var circlingShape := $CirclingHitbox.get_child(0)


func play_circling():
	circlingShape.disabled = false
	animationPlayer.play("Circling")
	

func stop_circling():
	circlingShape.disabled = true
	animationPlayer.stop(true)
