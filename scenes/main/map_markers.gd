extends Node2D
class_name MapMarkers

@onready var plot_locations: Array[Marker2D] = gather_markers($PlotLocations)
@onready var forest_locations: Array[Marker2D] = gather_markers($ForestLocations)
@onready var propable_player_locations: Array[Marker2D] = gather_markers($PlayerLocations)

@onready var well: Marker2D = $Well
@onready var shop: Marker2D = $Shop
@onready var player_home: Marker2D = $PlayerHome
@onready var scout_ants_bias: Marker2D = $ScoutAntsBias

func gather_markers(from: Node2D) -> Array[Marker2D]:
	var to: Array[Marker2D] = []

	for child in from.get_children():
		if child is Marker2D:
			to.append(child)

	return to
