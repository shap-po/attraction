extends BaseInventoryGrid
class_name ShopInventoryGrid

@export var player_inventory: PlayerInventory

func _ready() -> void:
	super._ready()

func on_pressed(index: int) -> void:
	super.on_pressed(index)

	var item: Item = inventory.get_item(index)
	if item == null:
		return

	buy_item(item)

func buy_item(item: Item) -> bool:
	if Money.value - item.buy_price < 0:
		return false

	var res: bool = player_inventory.add_item(item.duplicate())
	if res:
		Money.remove(item.buy_price)

	return res
