extends Menu

func _on_open() -> void:
	Global.pause_game()

func _on_close() -> void:
	Global.unpause_game()

func _on_back_button_pressed() -> void:
	close()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
