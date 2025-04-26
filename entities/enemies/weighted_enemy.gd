@tool
extends Resource
class_name WeightedEnemy

enum SpawnArea {
	TOP = 1,
	BOTTOM = 2,
	LEFT = 4,
	RIGHT = 8,
	FARM = 16
}

@export var enemy: PackedScene
@export_range(-100, 100) var weight: int
var spawn_area_mask: int

func _get_property_list() -> Array[Dictionary]:
	var proserties: Array[Dictionary] = []

	proserties.append({
		"name": "spawn_area_mask",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": ",".join(SpawnArea.keys().map(func(s: String): return s.to_pascal_case()))
	})

	return proserties
