extends Node2D
class_name Main

@onready var camera_2d: Camera2D = $Camera2D
@onready var items: Node2D = $items
@onready var player: CharacterBody2D = $player




func _ready() -> void:
	Global.main = self
	#temp_plant_connect()

	randomize()

func _process(_delta: float) -> void:
	camera_2d.position = player.position
