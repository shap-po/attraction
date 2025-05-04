## Base class for everything that can hold multiple items
extends Node
class_name BaseInventory

@export var _content: Array[Item] = []

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
