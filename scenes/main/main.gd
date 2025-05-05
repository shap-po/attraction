extends Node2D
class_name Main

@onready var camera_2d: Camera2D = $Camera2D
@onready var items: Node2D = $items
@onready var player: CharacterBody2D = $player
@onready var dummy: Node2D = %dummy



func _ready() -> void:
	Global.main = self
	#print_tree()
	#temp_plant_connect()

	randomize()

func _process(_delta: float) -> void:
	camera_2d.position = player.position

func _on_time_left_timer_timeout() -> void:
	Global.game_over()
