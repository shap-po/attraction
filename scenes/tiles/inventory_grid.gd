extends GridContainer
class_name InventoryGrid

@export var inventory: PlayerInventory
@onready var slots: Array = get_children()
var pressed_index: int = -1

func _ready() -> void:
	inventory.on_content_changed.connect(update_slot)
	update_slots()

func on_open() -> void:
	pass

func on_close() -> void:
	if pressed_index != -1:
		untoggle_slot(pressed_index)
		pressed_index = -1

func untoggle_slot(index: int) -> void:
	var slot: ItemButton = slots[index]
	slot.button.set_pressed_no_signal(false)

func on_pressed(index: int) -> void:
	if pressed_index == -1:
		# do not allow selecting an empty slot first
		if inventory.get_item(index) == null:
			untoggle_slot(index)
			return

		pressed_index = index
		return

	untoggle_slot(pressed_index)

	if pressed_index == index:
		pressed_index = -1
		return

	untoggle_slot(index)
	swap_slots(pressed_index, index)
	pressed_index = -1

func swap_slots(slot1: int, slot2: int) -> void:
	inventory.swap_slots(slot1, slot2)
	update_slot(slot1)
	update_slot(slot2)

func update_slot(slot_index: int):
	slots[slot_index].update(inventory._content[slot_index])

func update_slots():
	for i in slots.size():
		slots[i].update(inventory._content[i])
