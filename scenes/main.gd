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


@onready var plots: Node2D = $map/plots

var count_book: Dictionary = {
		"Chem Root": 0
	}


#func temp_plant_connect():
#	for child: Interactible in plots.get_children():
#		child.PlantPlanted.connect(on_plant_planted)
#		child.PlantDestroyed.connect(on_plant_destroyed)

#func on_plant_planted(plant_type: PlantType):
#	count_book[plant_type.name] += 1
	
#func on_plant_destroyed(plant_type: PlantType):
#	count_book[plant_type.name] -= 1
