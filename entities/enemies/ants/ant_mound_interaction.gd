extends Interactible

@onready var ant_mound: AntMound = $"../.."

func interact(_player: Player, item: Item) -> InteractionResult:
	if item.item_name == "Watering Can":
		ant_mound.free_ants()
		ant_mound.queue_free()
		return InteractionResult.SUCCESS
	return InteractionResult.PASS
