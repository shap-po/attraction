extends GridContainer

@export var inventory: PlayerInventory

@onready var slots: Array = $".".get_children()	

func _ready() -> void:
	inventory.on_content_changed.connect(update_slot)
	update_slots()

func update_slot(slot_index: int):
	slots[slot_index].update(inventory._content[slot_index])

func update_slots():
	for i in slots.size():
		slots[i].update(inventory._content[i])
