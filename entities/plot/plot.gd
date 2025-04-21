extends Node2D

@onready var plant_res: PackedScene = preload("res://entities/plant/plant.tscn")
var plant: Plant

func _ready() -> void:
	create_plant(load("res://assets/resources/plant_types/chem_root.tres") as PlantType)
	print(plant.plant_type.name)


func create_plant(plant_type: PlantType):
	if plant != null:
		plant.queue_free()
		
	plant = plant_res.instantiate()
	plant.plant_type = plant_type
