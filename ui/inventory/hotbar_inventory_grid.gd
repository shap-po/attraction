@tool # to disable inventory property in editor
extends BaseInventoryGrid
class_name HotbarInventoryGrid

@export var player_inventory: PlayerInventory
@onready var last_selected_slot: int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	inventory = player_inventory.hotbar
	super._ready()
	get_inventory().on_content_changed.connect(_update_slot)
	player_inventory.on_selected_slot_changed.connect(_update_selected_slot)
	_update_selected_slot()

func get_inventory() -> PlayerInventory.HotbarInventory:
	return inventory as PlayerInventory.HotbarInventory

func on_close() -> void:
	super.on_close()

func update_slot(slot: InventorySlot, item: Item) -> void:
	super.update_slot(slot, item)
	if item == null:
		return

	slot.item_price.visible = false
	# update count
	if item is CountableItem:
		slot.item_count.text = str(item.count)
		slot.item_count.visible = true
	else:
		slot.item_count.visible = false

func _validate_property(property: Dictionary) -> void:
	if property.name == "inventory":
		property.usage = PROPERTY_USAGE_NO_EDITOR

func on_pressed(index: int) -> void:
	player_inventory.selected_slot = index

func _update_selected_slot() -> void:
	slots[last_selected_slot].selected_indicator.visible = false
	slots[player_inventory.selected_slot].selected_indicator.visible = true
	last_selected_slot = player_inventory.selected_slot
