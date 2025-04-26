extends TileMapLayer

const DIRT_TILES: Array[Vector2i] = [
	Vector2i(6,3),
	Vector2i(7,3),
	Vector2i(8,3),
	Vector2i(6,4),
	Vector2i(7,4),
	Vector2i(8,4),
	Vector2i(6,5),
	Vector2i(7,5),
	Vector2i(8,5),
	Vector2i(6,6),
]

const PLOT: PackedScene = preload("res://entities/plot/plot.tscn")
@onready var plots: Node2D = $"../plots"

func _ready() -> void:
	populate_plots()

func populate_plots() -> void:
	for dirt_tile in DIRT_TILES:
		for pos in get_used_cells_by_id(-1, dirt_tile):
			var plot: Plot = PLOT.instantiate()
			plots.add_child(plot)
			plot.global_position = map_to_local(pos)
