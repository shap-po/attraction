extends Interactible

@onready var plant_node: Node2D = $PlantNode

var plant: Plant

func create_plant(plant_type: PlantType):
	if plant != null:
		plant.queue_free()

	plant = plant_type.create()
	plant_node.add_child(plant)

func interact(item: Item) -> InteractionResult:
	if plant != null:
		return InteractionResult.PASS

	if item is PlantType:
		create_plant(item as PlantType)
		return InteractionResult.SUCCESS

	return InteractionResult.PASS
