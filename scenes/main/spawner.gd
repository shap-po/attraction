extends TileMapLayer
class_name Spawner

signal incoming_wave(wave_location: WeightedEnemy.SpawnArea, bug_allert_timeout: int)

@onready var next_wave_timer: Timer = $NextWaveTimer
@onready var dummy: Node2D = %dummy
@onready var plots: Node2D = %Plots

const AREA_CORDS_ATLAS: Dictionary = {
	WeightedEnemy.SpawnArea.TOP: Vector2i(0, 0),
	WeightedEnemy.SpawnArea.BOTTOM: Vector2i(0, 2),
	WeightedEnemy.SpawnArea.LEFT: Vector2i(0, 1),
	WeightedEnemy.SpawnArea.RIGHT: Vector2i(1, 0),
	WeightedEnemy.SpawnArea.FARM: Vector2i(2, 0)
}
var spawn_positions: Dictionary = {} ## points on the map that correspond to spawn area

var enemies_pool: Array[WeightedEnemy] = []
var enemy_points: int = 0

var wave_location: WeightedEnemy.SpawnArea
var wave_enemies: Array[PackedScene] = []

func _ready() -> void:
	for area in WeightedEnemy.SpawnArea.values():
		spawn_positions[area] = self.get_used_cells_by_id(-1, AREA_CORDS_ATLAS[area])
	next_wave_timer.wait_time = Global.time_between_waves
	next_wave_timer.start()


func pick_and_spawn_enemy() -> void:
	if enemies_pool.size() == 0:
		return

	var enemy_to_spawn: WeightedEnemy = WeightedEnemy.choose(enemies_pool)
	if enemy_to_spawn == null:
		return

	for enemy_scene: PackedScene in enemy_to_spawn.enemies:
		var location_to_spawn: WeightedEnemy.SpawnArea = enemy_to_spawn.get_spawn_ares().pick_random()

		var new_enemy: Node2D = enemy_scene.instantiate()
		dummy.add_child(new_enemy)
		new_enemy.global_position = pick_coords(location_to_spawn)

## Prepares the next wave of enemies
func prepare_wave() -> void:
	# duplicate the pool and filter it
	var pool: Array[WeightedEnemy] = enemies_pool.duplicate()
	var points: int = enemy_points
	_filter_pool_by_points(pool, points)

	# pick the first enemy and get a spawn area
	var enemy: WeightedEnemy = WeightedEnemy.choose(pool)
	if enemy == null:
		return
		wave_location = enemy.get_spawn_ares().pick_random()
	_filter_pool_by_area(pool, wave_location)

	# add the enemy to the wave
	wave_enemies.append_array(enemy.enemies)
	points -= enemy.points_cost

	while points > 0:
		_filter_pool_by_points(pool, points)
		enemy = WeightedEnemy.choose(pool)
		if enemy == null:
			break

		wave_enemies.append_array(enemy.enemies)
		points -= enemy.points_cost


func _filter_pool_by_points(pool: Array[WeightedEnemy], points: int) -> void:
	var i: int = 0
	while i < pool.size():
		if pool[i].points_cost > points:
			pool.pop_at(i)
		else:
			i += 1

func _filter_pool_by_area(pool: Array[WeightedEnemy], area: WeightedEnemy.SpawnArea) -> void:
	var i: int = 0
	while i < pool.size():
		if pool[i].spawn_area_mask & int(area) == 0:
			pool.pop_at(i)
		else:
			i += 1

func _on_next_wave_timer_timeout() -> void:
	if wave_location == null or wave_enemies.size() == 0:
		prepare_wave()
		if wave_enemies.size() == 0:
			print("failed to prepare wave")
			return

		# allert the player and set the timer for the wave
		print("A wave incoming from ", Util.enum_to_str(WeightedEnemy.SpawnArea, wave_location), " in ", Global.bug_allert_timeout, " seconds!\nEnemies: ", wave_enemies)
		incoming_wave.emit(wave_location, Global.bug_allert_timeout)
		next_wave_timer.wait_time = Global.bug_allert_timeout
		return

	print("The wave is here!")
	for enemy in wave_enemies:
		if enemy == null:
			continue
		var new_enemy: Node2D = enemy.instantiate()
		dummy.add_child(new_enemy)
		new_enemy.global_position = pick_coords(wave_location)

	# reset the wave
	wave_enemies = []
	# reset the timer
	next_wave_timer.wait_time = Global.time_between_waves

func pick_coords(area: WeightedEnemy.SpawnArea) -> Vector2:
	var spawn_cords: Vector2i = spawn_positions[area].pick_random()
	return map_to_local(spawn_cords)

func recalculate_enemy_pools() -> void:
	enemies_pool = []
	enemy_points = 0

	for plot in plots.get_children():
		if plot is Plot and plot.plant != null and plot.plant.plant_type != null:
			var plant_type: PlantType = plot.plant.plant_type
			enemies_pool.append_array(plant_type.enemies_pool)
			enemy_points += plant_type.enemy_points
