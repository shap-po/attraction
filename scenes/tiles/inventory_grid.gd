extends GridContainer
class_name InventoryGrid

@export var inventory: PlayerInventory
@onready var slots: Array[InventoryItem] = []
var selected_slot: int = -1

func _ready() -> void:
	for s in get_children():
		if s is InventoryItem:
			slots.append(s)
		else:
			push_error(str(s) + " must be an InventoryItem")

	inventory.on_content_changed.connect(update_slot)
	update_slots()

func _process(_delta: float) -> void:
	if selected_slot == -1:
		return

	slots[selected_slot].item_content.global_position = get_global_mouse_position()


func on_open() -> void:
	pass

func on_close() -> void:
	if selected_slot != -1:
		slots[selected_slot].reset_content_position()
		selected_slot = -1

func on_pressed(index: int) -> void:
	if selected_slot == -1:
		# do not allow selecting an empty slot first
		if inventory.get_item(index) == null:
			return

		selected_slot = index
		return

	if selected_slot == index:
		selected_slot = -1
		return

	slots[selected_slot].reset_content_position()
	inventory.swap_slots(selected_slot, index)
	selected_slot = -1

func update_slot(slot_index: int):
	slots[slot_index].update(inventory._content[slot_index])

func update_slots():
	for i in slots.size():
		slots[i].update(inventory._content[i])
