@tool
extends PlayerInventoryGrid
class_name SellInventoryGrid

func on_pressed(index: int) -> void:
	sell_item(index)

func sell_item(index: int) -> bool:
	# check if item can be sold
	var item: Item = inventory.get_item(index)
	if item == null or item.sell_price == 0:
		return false

	# remove it from the inventory
	item = get_inventory().remove_item(index)

	# calc the price
	var price: int = item.sell_price
	if item is CountableItem:
		price *= item.count

	Money.add(price)
	return true
