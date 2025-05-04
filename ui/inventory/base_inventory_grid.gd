extends GridContainer
class_name BaseInventoryGrid

@export var slot_scene: PackedScene
@export var inventory: BaseInventory
@onready var slots: Array[InventorySlot] = []

func _ready() -> void:
	if get_children().size() != 0:
		push_error("Invenotry grid cannot have child nodes!")
		for n in get_children():
			remove_child(n)
			n.queue_free()

	for s in range(inventory._content.size()):
		var slot: InventorySlot = slot_scene.instantiate()
		add_child(slot)
		slots.append(slot)

	update_slots()

## Should be overridden in the child class to return the correct inventory type
func get_inventory() -> BaseInventory:
	return inventory

func on_open() -> void:
	pass

func on_close() -> void:
	pass

func on_pressed(index: int) -> void:
	pass

func update_slot(slot_index: int):
	slots[slot_index].update(inventory._content[slot_index])

func update_slots():
	for i in slots.size():
		slots[i].update(inventory._content[i])
