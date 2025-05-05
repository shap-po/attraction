extends Node

var main: Main
var bug_allert_timeout: int = 10 ## secons between allert and attack
var time_between_waves: int = 20 ## seconds between waves
var money_goal: int = 10_000

func game_over() -> void:
	Money.value = 0

func lose() -> void:
	game_over()
	get_tree().change_scene_to_file("res://scenes/menus/game_over/game_over.tscn")

func win() -> void:
	game_over()
	get_tree().change_scene_to_file("res://scenes/menus/game_over/win.tscn")
