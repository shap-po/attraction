extends Control

@onready var options: PackedScene = preload("res://ui/options/options.tscn")

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options_button_pressed() -> void:
	get_tree().current_scene.add_child(options.instantiate())

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
