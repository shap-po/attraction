@tool
extends BaseInventoryGrid
class_name SellInventoryGrid

func _ready() -> void:
	super._ready()
	get_inventory().on_content_changed.connect(update_slot)


func on_pressed(index: int) -> void:
	super.on_pressed(index)

	sell_item(index)

func sell_item(index: int) -> bool:
	# check if item can be sold
	var item: Item = inventory.get_item(index)
	if item == null or item.sell_price == 0:
		return false

	# remove it from the inventory
	item = get_inventory().remove_item(index)

	# calc the price
	var price = item.sell_price
	if item is CountableItem:
		price *= item.count

	Money.add(price)
	return true

func get_inventory() -> PlayerInventory:
	return inventory as PlayerInventory

func _validate_property(property: Dictionary) -> void:
	# override inventory type hint
	if property.name == "inventory":
		property.hint_string = "PlayerInventory"
