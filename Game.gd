extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart_game()

func restart_game():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
