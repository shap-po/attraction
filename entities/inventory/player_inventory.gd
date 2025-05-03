extends Inventory
class_name PlayerInventory

signal on_selected_slot_changed()

const hotbar_size: int = 9

@onready var player: Player = $".."

var selected_slot: int = 0:
	set(val):
		selected_slot = val % _content.size()
		if selected_slot < 0:
			selected_slot += _content.size()
		on_selected_slot_changed.emit()

func get_selected_item() -> Item:
	return get_item(selected_slot)

func get_hotbar() -> Array[Item]:
	var hotbar: Array[Item] = []
	for i in range(hotbar_size):
		hotbar.append(get_item(i))
	return hotbar

func add_item_or_drop(item: Item) -> void:
	var res: bool = add_item(item)
	if not res:
		var world_item: WorldItem = item.create_world_item()
		Global.main.items.add_child(world_item)
		world_item.global_position = player.global_position
