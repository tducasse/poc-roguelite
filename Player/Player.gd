extends KinematicBody2D

class_name Player

const DEFAULT_CHAR_INDEX = 0


# Action Buttons
const UI_RIGHT = "ui_right"
const UI_LEFT = "ui_left"
const UI_UP = "ui_up"
const UI_DOWN = "ui_down"


# Local vars
var velocity = Vector2.ZERO
var type setget ,get_type
var active_character = null
var active_character_index = 0
var available_characters_indexes = [0]

# onready vars
onready var characters := $Characters.get_children()
onready var smoke := $Smoke


func _ready():
	active_character = characters[DEFAULT_CHAR_INDEX]
	active_character.enable()
	smoke.visible = false


func play_smoke_animation():
	smoke.visible = true
	smoke.frame = 0
	smoke.play()


func is_allowed_to_transform(index):
	return index in available_characters_indexes
	
	
func toggle_active_character(index):
	if active_character_index != index and is_allowed_to_transform(index):
		play_smoke_animation()
		active_character.disable()
		active_character = characters[index]
		active_character.enable()
		active_character_index = index
		

func add_available_character(index):
	available_characters_indexes.append(index)


func check_active_character(event):
	if event.is_action_pressed("toggle1"):
		toggle_active_character(0)
	elif event.is_action_pressed("toggle2"):
		toggle_active_character(1)


func _input(event):
	check_active_character(event)
	

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength(UI_RIGHT) - Input.get_action_strength(UI_LEFT),
		Input.get_action_strength(UI_DOWN) - Input.get_action_strength(UI_UP)
	).normalized()

	# send the vector to every character, so that they can stay in sync
	# even if they are not currently active
	for character in characters:
		character.receive_input_vector(input_vector)


func get_type():
	return "Player"


func move(value):
	velocity = move_and_slide(value)


func _on_CoatPlayer_on_move(value):
	move(value)


func _on_NakedPlayer_on_move(value):
	move(value)


func _on_Smoke_animation_finished():
	smoke.visible = false


func _on_PickItems_pick_item(item_type, item_data):
	if item_type == "character":
		add_available_character(item_data)
		toggle_active_character(item_data)
