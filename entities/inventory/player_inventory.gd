extends EditableInventory
class_name PlayerInventory

signal on_selected_slot_changed()

const CHEM_ROOT: PlantType = preload("res://assets/resources/items/plant_types/chem_root.tres")
const hotbar_size: int = 9

@onready var player: Player = get_parent()

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
	add_starter_kit()
	hotbar._content = _content.slice(0, hotbar_size)
	on_content_changed.connect(_on_content_changed)

func add_starter_kit() -> void:
	var seeds = CHEM_ROOT.duplicate()
	seeds.count = 5
	add_item(seeds)

func _on_content_changed(slot: int) -> void:
	if slot < hotbar_size:
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
