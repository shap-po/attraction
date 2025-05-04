@tool
extends BaseInventoryGrid
class_name HotbarInventoryGrid

@export var player_inventory: PlayerInventory
@onready var last_selected_slot: int = 0

func _ready() -> void:
	inventory = player_inventory.hotbar
	super._ready()
	get_inventory().on_content_changed.connect(_update_slot)

func get_inventory() -> PlayerInventory.HotbarInventory:
	return inventory as PlayerInventory.HotbarInventory

func on_close() -> void:
	super.on_close()

func update_slot(slot: InventorySlot, item: Item) -> void:
	super.update_slot(slot, item)
	if item == null:
		return

	# update count
	if item is CountableItem:
		slot.item_count.text = str(item.count)
		slot.item_count.visible = true
	else:
		slot.item_count.visible = false

func _validate_property(property: Dictionary) -> void:
	# override inventory type hint
	if property.name == "inventory":
		property.usage = PROPERTY_USAGE_NO_EDITOR

func on_pressed(index: int) -> void:
	player_inventory.selected_slot = index

func _on_inventory_on_selected_slot_changed() -> void:
	slots[player_inventory.selected_slot].selected_indicator.visible = true
	slots[last_selected_slot].selected_indicator.visible = false
	last_selected_slot = player_inventory.selected_slot
