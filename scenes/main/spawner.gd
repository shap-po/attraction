extends TileMapLayer

@onready var dummy: Node2D = %dummy
var weighted_enemies_spawn: Array[WeightedEnemy] = []

var spawn_positions_dict: Dictionary = {}
const AREA_CORDS_ATLAS: Dictionary = {
	WeightedEnemy.SpawnArea.TOP: Vector2i(0,0),
	WeightedEnemy.SpawnArea.BOTTOM: Vector2i(0,2),
	WeightedEnemy.SpawnArea.LEFT: Vector2i(0,1),
	WeightedEnemy.SpawnArea.RIGHT: Vector2i(1,0),
	WeightedEnemy.SpawnArea.FARM: Vector2i(2,0)
}
func _ready() -> void:
	for e in WeightedEnemy.SpawnArea.values():
		spawn_positions_dict[e] = self.get_used_cells_by_id(-1,AREA_CORDS_ATLAS[e])


func natural_spawn_enemy(): ## spawns enemy with weights in here on location
	if !weighted_enemies_spawn:
		return
	var enemy_to_spawn = WeightedEnemy.choose(weighted_enemies_spawn)
	var location_to_spawn = enemy_to_spawn.get_spawn_ares().pick_random()
	var spawn_cords = spawn_positions_dict[location_to_spawn].pick_random()
	
	var new_enemy = enemy_to_spawn.enemy.instantiate()
	dummy.add_child(new_enemy) 
	new_enemy.global_position = map_to_local(spawn_cords)
	
