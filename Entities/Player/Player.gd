extends KinematicBody2D

class_name Player

const DEFAULT_CHAR_INDEX = 0

enum states {
	MOVE,
	ATTACK,
	TRANSFORM1,
	TRANSFORM2
}

# Action Buttons
const UI_RIGHT = "ui_right"
const UI_LEFT = "ui_left"
const UI_UP = "ui_up"
const UI_DOWN = "ui_down"
const ATTACK = "attack"
const TOGGLE1 = "toggle1"
const TOGGLE2 = "toggle2"


# Local vars
var state = states.MOVE
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
	var player_stats_connection = PlayerStats.connect("no_health", self, "_on_stats_no_health")
	if player_stats_connection != OK:
		print_debug("Connection to no_health signal failed : " + player_stats_connection)

func _physics_process(_delta):
	match state:
		states.MOVE:
			move_state()
		states.ATTACK:
			attack_state()
		states.TRANSFORM1:
			transform1_state()
		states.TRANSFORM2:
			transform2_state()


func move_state():
	var input_vector = Vector2(
		Input.get_action_strength(UI_RIGHT) - Input.get_action_strength(UI_LEFT),
		Input.get_action_strength(UI_DOWN) - Input.get_action_strength(UI_UP)
	).normalized()
	
	# send the vector to every character, so that they can stay in sync
	# even if they are not currently active
	for character in characters:
		character.receive_input_vector(input_vector)
		
	if Input.is_action_just_pressed(ATTACK):
		state = states.ATTACK
	elif Input.is_action_just_pressed(TOGGLE1):
		state = states.TRANSFORM1
	elif Input.is_action_just_pressed(TOGGLE2):
		state = states.TRANSFORM2


func attack_state():
	attack()


func transform1_state():
	toggle_active_character(0)
	state = states.MOVE


func transform2_state():
	toggle_active_character(1)
	state = states.MOVE


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
	if event.is_action_pressed(TOGGLE1):
		toggle_active_character(0)
	elif event.is_action_pressed(TOGGLE2):
		toggle_active_character(1)


func attack():
	if active_character.has_method("attack"):
		active_character.attack()
	else :
		state = states.MOVE


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
	match item_type:
		"Character":
			var index = item_data['index']
			add_available_character(index)
			toggle_active_character(index)
		"Item":
			# TODO: actually implement this part + inventory
			print_debug('picked ', item_type, ' ', item_data['name'])


func _on_CoatPlayer_on_attack_end(_value):
	state = states.MOVE


func _on_stats_no_health():
	queue_free()


func _on_Hurtbox_area_entered(area):
	PlayerStats.health -= area.damage
