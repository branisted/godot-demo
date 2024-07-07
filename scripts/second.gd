extends Node2D

func _process(delta):
	change_scene()
	
func _on_first_teleport_body_entered(body):
	if body.has_method("player"):
		Global.transition_scene = true

func change_scene():
	if Global.transition_scene:
		if Global.current_scene == "second":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_change_scene()
