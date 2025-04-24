extends Node
class_name Inventory

signal on_inventory_changed(slot: int)

@export var inventory_size: int = 9 * 4
var inventory: Array[Item] = []

func _ready() -> void:
	for i in range(inventory_size):
		inventory.append(null)

func is_in_bounds(slot: int) -> bool:
	return slot >= 0 and slot < inventory_size

func get_item(slot: int) -> Item:
	if not is_in_bounds(slot):
		return null

	return inventory[slot]

func add_item(item: Item, slot: int = -1) -> bool:
	if slot == -1:
		slot = find_empty_slot()

	if not is_in_bounds(slot):
		return false

	var existing_item: Item = get_item(slot)
	if existing_item != null:
		if existing_item is CountableItem and item is CountableItem and existing_item.item_name == item.item_name:
			existing_item.count += (item as CountableItem).count
			on_inventory_changed.emit(slot)
			return true
		else:
			return false

	inventory[slot] = item
	on_inventory_changed.emit(slot)
	return true

func remove_item(slot: int, count: int = -1) -> Item:
	assert(count == -1 or count > 0, "Count must be -1 or greater than 0")

	if not is_in_bounds(slot):
		return null

	var item: Item = get_item(slot)
	if item == null:
		return null

	# for countable items, remove the specified count
	if item is CountableItem and (count != -1 or count < item.count):
		item.count -= count
		var item_copy: CountableItem = item.duplicate()
		item_copy.count = count
		on_inventory_changed.emit(slot)
		return item_copy

	inventory[slot] = null
	on_inventory_changed.emit(slot)
	return item

func find_empty_slot() -> int:
	for i in range(inventory_size):
		if inventory[i] == null:
			return i

	return -1
