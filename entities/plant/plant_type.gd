extends Item
class_name PlantType

const PLANT: PackedScene = preload("res://entities/plant/plant.tscn")

@export_range(0, 3600)
var growTime: int ## In seconds
@export var grow_stages: Array[Texture2D]
@export var grown_sell_price: int

func _init() -> void:
	item_type = ItemType.SEED

func create() -> Plant:
	var instance: Plant = PLANT.instantiate()
	instance.plant_type = self
	return instance
