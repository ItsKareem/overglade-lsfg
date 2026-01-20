extends CanvasLayer

func _on_texture_button_pressed() -> void:
	get_tree().reload_current_scene()
