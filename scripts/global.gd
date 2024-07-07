extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		EscHold()

func EscHold():
	if !Input.is_action_pressed("Esc"):
		return
	await get_tree().create_timer(1).timeout
	if !Input.is_action_pressed("Esc"):
		return
	get_tree().quit()
	
var player_current_attack = false

var current_scene = "world"
var transition_scene = false

var player_start_second_posx = 44
var player_start_second_posy = 136

var player_exit_second_posx = 215
var player_exit_second_posy = 10

var game_firstloadin = true

var player_health = 100

func finish_change_scene():
	if transition_scene:
		transition_scene = false
		match current_scene:
			"world":
				current_scene = "second"
			"second":
				current_scene = "world"
