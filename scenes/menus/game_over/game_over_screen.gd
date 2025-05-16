extends Control
class_name GameOverScreen

func _ready() -> void:
	visible = false

func activate() -> void:
	visible = true
	Engine.time_scale = 0.0

func _on_start_button_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_endless_pressed() -> void:
	Global.main.set_endless()
	Engine.time_scale = 1.0
	visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
