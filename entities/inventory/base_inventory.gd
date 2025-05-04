## Base class for everything that can hold multiple items
extends Node
class_name BaseInventory

@export var _content: Array[Item] = []

func is_in_bounds(slot: int) -> bool:
	return slot >= 0 and slot < _content.size()

func get_item(slot: int) -> Item:
	if not is_in_bounds(slot):
		return null

	return _content[slot]

func find_empty_slot() -> int:
	for i in range(_content.size()):
		if _content[i] == null:
			return i

	return -1

func find_item(item: Item) -> int:
	for i in range(_content.size()):
		if _content[i] != null and _content[i].equals(item):
			return i

	return -1

func _to_string() -> String:
	return self.name + ": {size: " + str(_content.size()) + ", content: " + str(_content) + "}"
