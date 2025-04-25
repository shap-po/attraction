extends Interactible

@onready var plant_node: Node2D = $PlantNode
var plant: Plant

func create_plant(plant_type: PlantType):
	if plant != null:
		plant.queue_free()

	plant = plant_type.create()
	plant_node.add_child(plant)

func harvest() -> Item:
	if plant != null:
		return plant.harvest()

	return null

func interact(player: Player, item: Item) -> InteractionResult:
	if plant != null:
		if plant.is_fully_grown():
			var harvested: Item = harvest()
			player.inventory.add_item_or_drop(harvested)

			return InteractionResult.SUCCESS

		return InteractionResult.PASS

	if item is PlantType:
		create_plant(item as PlantType)
		return InteractionResult.SUCCESS

	return InteractionResult.PASS
