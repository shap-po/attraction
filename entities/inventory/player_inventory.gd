extends Inventory
class_name PlayerInventory

signal on_selected_slot_changed()

const hotbar_size: int = 9

var selected_slot: int = 0:
	set(val):
		selected_slot = val % size
		if selected_slot < 0:
			selected_slot += size
		on_selected_slot_changed.emit()

var cursour_item: Item = null ## Dragged item

func get_selected_item() -> Item:
	return get_item(selected_slot)

func get_hotbar() -> Array[Item]:
	var hotbar: Array[Item] = []
	for i in range(hotbar_size):
		hotbar.append(get_item(i))
	return hotbar
