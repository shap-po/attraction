extends Node

var main: Main
var bug_allert_timeout: int = 5 ## secons between allert and attack
var time_between_waves: int = 10 ## seconds between waves
var money_goal: int = 10_000

func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/game_over/game_over.tscn")

func win() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/game_over/win.tscn")
