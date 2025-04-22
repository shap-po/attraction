extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $player

func _process(delta: float) -> void:
	camera_2d.position = player.position
