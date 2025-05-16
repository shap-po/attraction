extends Node2D
class_name Main

@onready var camera_2d: Camera2D = $Camera2D
@onready var items: Node2D = $Items
@onready var player: CharacterBody2D = $Player
@onready var dummy: Node2D = %Dummy
@onready var plots: Node2D = %Plots
@onready var map_markers: MapMarkers = $Map/MapMarkers

func _ready() -> void:
	Global.main = self
	randomize()

func _process(_delta: float) -> void:
	camera_2d.position = player.position

func _on_time_left_timer_timeout() -> void:
	Global.lose()
