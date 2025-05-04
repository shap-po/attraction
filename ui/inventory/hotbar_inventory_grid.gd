@tool
extends BaseInventoryGrid
class_name HotbarInventoryGrid

@export var player_inventory: PlayerInventory

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
