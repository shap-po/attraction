## Base class for everything that can hold multiple items
extends Node
class_name Inventory

signal on_content_changed(slot: int)

@export var size: int = 9 * 4
var _content: Array[Item] = []


func _ready() -> void:
	_init_content()

func _init_content() -> void:
	_content = []
	for i in range(size):
		_content.append(null)

func is_in_bounds(slot: int) -> bool:
	return slot >= 0 and slot < size

func get_item(slot: int) -> Item:
	if not is_in_bounds(slot):
		return null

	return _content[slot]

func add_item(item: Item, slot: int = -1) -> bool:
	if item == null:
		return false

	if slot == -1:
		if item is CountableItem:
			slot = find_item(item)
		else:
			slot = find_empty_slot()

	if not is_in_bounds(slot):
		return false

	var existing_item: Item = _content[slot]
	if existing_item != null:
		if item is CountableItem and existing_item.equals(item):
			(existing_item as CountableItem).count += (item as CountableItem).count
			on_content_changed.emit(slot)
			return true
		else:
			return false

	_content[slot] = item
	on_content_changed.emit(slot)
	return true

func remove_item(slot: int, count: int = -1) -> Item:
	assert(count == -1 or count > 0, "Count must be -1 or greater than 0")

	if not is_in_bounds(slot):
		return null

	var item: Item = _content[slot]
	if item == null:
		return null

	# for countable items, remove the specified count
	if item is CountableItem and (count != -1 or count < item.count):
		item.count -= count
		var item_copy: CountableItem = item.duplicate()
		item_copy.count = count
		on_content_changed.emit(slot)
		return item_copy

	_content[slot] = null
	on_content_changed.emit(slot)
	return item

func find_empty_slot() -> int:
	for i in range(size):
		if _content[i] == null:
			return i

	return -1

func find_item(item: Item) -> int:
	for i in range(size):
		if _content[i] != null and _content[i].equals(item):
			return i

	return -1
