extends EditableInventory
class_name PlayerInventory

signal on_selected_slot_changed()
signal on_hotbar_changed(slot: int)

const hotbar_size: int = 9


@onready var player: Player = $".."

var selected_slot: int = 0:
	set(val):
		selected_slot = val % hotbar_size
		if selected_slot < 0:
			selected_slot += hotbar_size
		on_selected_slot_changed.emit()
		

var hotbar: HotbarInventory = HotbarInventory.new()

class HotbarInventory extends BaseInventory:
	signal on_content_changed(slot: int)

func _ready() -> void:
	hotbar._content.resize(hotbar_size)
	hotbar._content.fill(null)
	on_content_changed.connect(_on_content_changed)

func _on_content_changed(slot: int) -> void:
	if slot <= hotbar_size:
		hotbar._content[slot] = _content[slot]
		hotbar.on_content_changed.emit(slot)

func get_selected_item() -> Item:
	return get_item(selected_slot)

func add_item_or_drop(item: Item) -> void:
	var res: bool = add_item(item)
	if not res:
		var world_item: WorldItem = item.create_world_item()
		Global.main.items.add_child(world_item)
		world_item.global_position = player.global_position
