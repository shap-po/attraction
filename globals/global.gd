extends Node

var main: Main
var bug_allert_timeout: int = 10 ## secons between allert and attack
var time_between_waves: int = 20 ## seconds between waves
var money_goal: int = 10_000

func pause_game() -> void:
	get_tree().paused = true

func unpause_game() -> void:
	get_tree().paused = false
