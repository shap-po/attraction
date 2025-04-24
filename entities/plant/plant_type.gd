@tool
extends CountableItem
class_name PlantType

enum CropType {
	VEGETABLE, ## Can be harvested once
	BUSH ## Can be harvested multiple times
}

const PLANT: PackedScene = preload("res://entities/plant/plant.tscn")

@export var crop_name: String
@export var crop_type: CropType
@export_range(0, 3600) var grow_time: int ## In seconds
@export var grow_stages: Array[Texture2D]

@export_group("Fruit Item Properties")
@export var grown_sell_price: int
@export var fruit_item_texture: Texture2D
# Specific for bushes
@export_group("Bush Properties")
@export_range(0, 10) var bush_harvest_limit: int
@export var bush_stages_per_harvest: int = 1 ## Number of growth stages to remove when harvesting


func _init() -> void:
	# set item properties
	item_type = ItemType.SEED
	item_name = crop_name + " Seed"

func create() -> Plant:
	var instance: Plant = PLANT.instantiate()
	instance.plant_type = self
	return instance

func _validate_property(property: Dictionary) -> void:
	# hide properties that are set automatically
	if property.name in ["item_name", "item_type"]:
		property.usage = PROPERTY_USAGE_NONE
	# hide bush properties if crop type is not bush
	if crop_type != CropType.BUSH and property.name in ["bush_harvest_limit", "bush_stages_per_harvest"]:
		property.usage = PROPERTY_USAGE_NONE
