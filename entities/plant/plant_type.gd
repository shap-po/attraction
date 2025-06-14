@tool # to hide properties in editor
extends CountableItem
class_name PlantType

enum CropType {
	VEGETABLE, ## Can be harvested once
	BUSH ## Can be harvested multiple times
}

const PLANT: PackedScene = preload("res://entities/plant/plant.tscn")

@export var crop_name: String:
	set(val):
		crop_name = val
		item_name = crop_name + " Seed"

@export var crop_type: CropType:
	set(val):
		crop_type = val
		notify_property_list_changed()

@export_range(0, 3600) var grow_time: int ## In seconds
@export var grow_stages: Array[Texture2D]
@export var health: int
@export_group("Fruit Item Properties")
@export var grown_sell_price: int
@export var fruit_item_texture: Texture2D
## How likely is the plant to replant itself on nearby plots
@export_range(0.0, 1.0, 0.05) var invasion_chance: float = 0.0
# Specific for bushes
@export_group("Bush Properties")
@export_range(0, 10) var bush_harvest_limit: int
@export var bush_stages_per_harvest: int = 1 ## Number of growth stages to remove when harvesting
@export_group("Enemies")
@export var enemies_pool: Array[WeightedEnemy] = []
@export_range(0, 20, 1, "or_greater") var enemy_points: int
@export var ant_points: int = 0


func create() -> Plant:
	var instance: Plant = PLANT.instantiate()
	instance.plant_type = self
	return instance

func _validate_property(property: Dictionary) -> void:
	# hide properties that are set automatically
	if property.name in ["item_name"]:
		property.usage = PROPERTY_USAGE_NONE
	# hide bush properties if crop type is not bush
	if crop_type != CropType.BUSH and property.name in ["bush_harvest_limit", "bush_stages_per_harvest"]:
		property.usage = PROPERTY_USAGE_NONE
