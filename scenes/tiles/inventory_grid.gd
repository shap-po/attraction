extends GridContainer

class_name InventoryGrid

@export var inventory: PlayerInventory

@onready var slots: Array = get_children()

func _ready() -> void:
	inventory.on_content_changed.connect(update_slot)
	update_slots()

func get_pressed_index(index):
	return index


func pick_slots() -> void:
	var slot1
	var slot2
	
	pass

func swap_slots(slot1: int, slot2: int) -> void:
	inventory.swap_slots(slot1, slot2)
	update_slot(slot1)
	update_slot(slot2)

func update_slot(slot_index: int):
	slots[slot_index].update(inventory._content[slot_index])

func update_slots():
	for i in slots.size():
		slots[i].update(inventory._content[i])
		
		
