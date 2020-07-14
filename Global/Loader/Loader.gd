extends Node

var current_scene = null
var player_preload = preload("res://Entities/Player/Player.tscn")

func _ready():
	randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Initializing player
	var player = player_preload.instance()
	get_tree().get_nodes_in_group("World")[0].add_child(player)
	player.position = get_tree().get_nodes_in_group("InitSpawnPos")[0].position


func goto_scene(path, spawn_pos_name: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, spawn_pos_name)


func _deferred_goto_scene(path, spawn_pos_name: String):
	# Save the Player
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.get_parent().remove_child(player)
	
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Add player
	get_tree().get_nodes_in_group("World")[0].add_child(player)
	player.position = get_tree().get_nodes_in_group(spawn_pos_name)[0].position
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
