extends Node2D
class_name Main

@onready var camera_2d: Camera2D = $Camera2D
@onready var items: Node2D = $Items
@onready var player: CharacterBody2D = $Player
@onready var dummy: Node2D = %Dummy
@onready var plots: Node2D = %Plots
@onready var map_markers: MapMarkers = $Map/MapMarkers
@onready var money_manager: MoneyManager = $MoneyManager

@onready var game_over_menu: GameOverScreen = $UICanvasLayer/GameOverMenu
@onready var win_menu: GameOverScreen = $UICanvasLayer/WinMenu
@onready var health_bar: TextureProgressBar = $UICanvasLayer/health_bar
var endless_mode: bool = false

func _ready() -> void:
	Global.main = self
	randomize()
	Global.on_main_ready.emit()

func _process(_delta: float) -> void:
	camera_2d.position = player.position

func lose() -> void:
	game_over_menu.activate()

func win() -> void:
	win_menu.activate()

func set_endless() -> void:
	endless_mode = true
	health_bar.hide() # no need for health if player can't die

func _on_game_timer_on_game_over() -> void:
	if not endless_mode:
		lose()
