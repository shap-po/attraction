extends Node

@export var player_inventory: PlayerInventory

func buy_item(item: Item) -> bool:
	if Money.value - item.buy_price < 0:
		return false

	var res: bool = player_inventory.add_item(item)
	if res:
		Money.remove(item.buy_price)

	return res
