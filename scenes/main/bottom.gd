extends TileMapLayer

const DIRT_TILES: Array[Vector2i] = [
Vector2i(6, 3),
Vector2i(7, 3),
Vector2i(8, 3),
Vector2i(6, 4),
Vector2i(7, 4),
Vector2i(8, 4),
Vector2i(6, 5),
Vector2i(7, 5),
Vector2i(8, 5),
Vector2i(6, 6),
]

const PLOT: PackedScene = preload("res://entities/plot/plot.tscn")
@onready var plots: Node2D = %Plots
@onready var spawner: Spawner = %Spawner


func _ready() -> void:
	populate_plots()

func populate_plots() -> void:
	var plot_nodes: Dictionary = {}
	var plot: Plot
	for dirt_tile in DIRT_TILES:
		for pos in get_used_cells_by_id(-1, dirt_tile):
			plot = PLOT.instantiate()
			plots.add_child(plot)
			plot.global_position = map_to_local(pos)

			plot.on_plant_added.connect(on_plant_added)
			plot.on_plant_removed.connect(on_plant_removed)
			plot_nodes[pos] = plot

	for local_pos in plot_nodes.keys():
		plot = plot_nodes[local_pos]
		var neighbors: Array[Plot] = []
		for offset in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor_pos: Vector2i = local_pos + offset
			if plot_nodes.has(neighbor_pos):
				neighbors.append(plot_nodes[neighbor_pos])
		plot.siblings = neighbors


func on_plant_added(plant_type: PlantType) -> void:
	spawner.enemies_pool.append_array(plant_type.enemies_pool)
	spawner.enemy_points += plant_type.enemy_points

func on_plant_removed(plant_type: PlantType) -> void:
	Util.remove_array(spawner.enemies_pool, plant_type.enemies_pool)
	spawner.enemy_points -= plant_type.enemy_points
