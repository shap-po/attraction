extends Control


func _ready() -> void:
	$VBoxContainer/ExitButton.grab_focus()

func _on_exit_button_pressed() -> void:
	queue_free()
