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

@export var name: String ## For developer usage
@export var enemies: Array[PackedScene] = []
@export_range(0, 100) var weight: int
@export_range(0, 20, 1, "or_greater") var points_cost: int
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

func get_spawn_ares() -> Array[SpawnArea]:
	var areas: Array[SpawnArea] = []
	for area in SpawnArea.values():
		if spawn_area_mask & area != 0:
			areas.append(area)
	return areas

static func choose(enemy_pool: Array[WeightedEnemy]) -> WeightedEnemy:
	var total_weight: int = 0
	for weighted in enemy_pool:
		total_weight += weighted.weight

	if total_weight == 0:
		return null

	var random_value: int = randi() % total_weight
	for weighted in enemy_pool:
		if random_value < weighted.weight:
			return weighted
		random_value -= weighted.weight

	return null
