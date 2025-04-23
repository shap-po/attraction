extends Interactible

@onready var plant_node: Node2D = $PlantNode

var plant: Plant

func create_plant(plant_type: PlantType):
	if plant != null:
		plant.queue_free()

	plant = plant_type.create()
	plant_node.add_child(plant)

func interact(item) -> InteractionResult:
	if plant != null:
		return InteractionResult.FAIL

	create_plant(load("res://assets/resources/plant_types/chem_root.tres") as PlantType)
	return InteractionResult.SUCCESS
