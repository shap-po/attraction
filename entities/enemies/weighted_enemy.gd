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

func get_spawn_ares() -> Array[SpawnArea]:
	var areas: Array[SpawnArea] = []
	for are in SpawnArea.values():
		if spawn_area_mask & are != 0:
			areas.append(are)
	return areas

static func choose(enemies: Array[WeightedEnemy]) -> WeightedEnemy:
	var total_weight: int = 0
	for enemy in enemies:
		total_weight += enemy.weight

	var random_value: int = randi() % total_weight
	for enemy in enemies:
		if random_value < enemy.weight:
			return enemy
		random_value -= enemy.weight

	return null
