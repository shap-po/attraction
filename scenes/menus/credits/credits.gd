extends Control


func _ready() -> void:
	$VBoxContainer/ExitButton.grab_focus()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
