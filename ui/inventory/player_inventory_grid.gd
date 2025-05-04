@tool
extends BaseInventoryGrid
class_name PlayerInventoryGrid

var selected_slot: int = -1

func _ready() -> void:
	super._ready()
	get_inventory().on_content_changed.connect(_update_slot)

func _process(_delta: float) -> void:
	if selected_slot == -1:
		return

	slots[selected_slot].item_content.global_position = get_global_mouse_position()

func get_inventory() -> PlayerInventory:
	return inventory as PlayerInventory

func on_close() -> void:
	super.on_close()
	if selected_slot != -1:
		reset_slot_content_position(selected_slot)
		selected_slot = -1

func on_pressed(index: int) -> void:
	super.on_pressed(index)
	if selected_slot == -1:
		# do not allow selecting an empty slot first
		if inventory.get_item(index) == null:
			return

		selected_slot = index
		slots[index].item_content.z_index = 1
		slots[index].item_content.z_as_relative = true
		return

	if selected_slot == index:
		reset_slot_content_position(selected_slot)
		selected_slot = -1
		return

	reset_slot_content_position(selected_slot)
	get_inventory().swap_slots(selected_slot, index)
	selected_slot = -1


func reset_slot_content_position(index: int) -> void:
	var slot: InventorySlot = slots[index]
	slot.item_content.global_position = slot.button.global_position
	slots[index].item_content.z_index = 0
	slot.item_content.z_as_relative = false

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
	# update price
	if item.sell_price != 0:
		slot.item_price.visible = true
		slot.item_price.text = str(item.sell_price)
	else:
		slot.item_price.visible = false

func _validate_property(property: Dictionary) -> void:
	# override inventory type hint
	if property.name == "inventory":
		property.hint_string = "PlayerInventory"
