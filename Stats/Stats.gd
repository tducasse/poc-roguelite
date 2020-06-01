extends Node


export var maxHealth = 1 setget set_max_health
var health = maxHealth setget set_health

signal no_health
signal on_health_change(value)
signal on_max_health_change(value)


func set_health(value: int):
	health = value
	emit_signal("on_health_change", health)
	if health <= 0:
		emit_signal("no_health")
		
		
func set_max_health(value: int):
	maxHealth = value
	self.health = min(health, maxHealth)
	emit_signal("on_max_health_change", maxHealth)


func _ready():
	self.health = maxHealth
