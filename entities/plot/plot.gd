extends Interactible
class_name Plot

signal on_plant_added(plant_type: PlantType)
signal on_plant_removed(plant_type: PlantType)
signal on_plant_fully_grown(plant_type: PlantType)

@onready var plant_node: Node2D = $PlantNode
var plant: Plant
var siblings: Array[Plot] = []

func create_plant(plant_type: PlantType):
	if plant != null:
		on_plant_removed.emit(plant.plant_type)
		plant.queue_free()

	plant = plant_type.create()
	plant.on_before_remove.connect(remove_plant)
	plant.on_fully_grown.connect(func(): on_plant_fully_grown.emit(plant.plant_type))
	plant.plot = self
	plant_node.add_child(plant)
	on_plant_added.emit(plant_type)

func harvest() -> Item:
	if plant != null:
		return plant.harvest()

	return null

func remove_plant() -> void:
	on_plant_removed.emit(plant.plant_type)
	plant = null

func interact(player: Player, item: Item) -> InteractionResult:
	if plant != null:
		if plant.is_fully_grown():
			var harvested: Item = harvest()
			player.inventory.add_item_or_drop(harvested)

			return InteractionResult.SUCCESS

		return InteractionResult.PASS

	if item is PlantType:
		create_plant(item as PlantType)
		return InteractionResult.CONSUME

	return InteractionResult.PASS
