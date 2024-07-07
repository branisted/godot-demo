extends Node2D

func _ready():
	if Global.game_firstloadin:
		$player.position.x = Global.player_start_second_posx
		$player.position.y = Global.player_start_second_posy
	else:
		$player.position.x = Global.player_exit_second_posx
		$player.position.y = Global.player_exit_second_posy

func _process(delta):
	change_scene()

func _on_second_plane_teleport_body_entered(body):
	if body.has_method("player"):
		Global.transition_scene = true

func change_scene():
	if Global.transition_scene:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/second.tscn")
			Global.game_firstloadin = false
			Global.finish_change_scene()
