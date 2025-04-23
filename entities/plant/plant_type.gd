extends Resource
class_name PlantType

const PLANT: PackedScene = preload("res://entities/plant/plant.tscn")

@export var name: String
@export var texture: Texture2D
@export var grow_stages: Array[Texture2D]

@export_range(0, 3600)
var growTime: int ## In seconds

func create() -> Plant:
	var instance: Plant = PLANT.instantiate()
	instance.plant_type = self
	return instance
