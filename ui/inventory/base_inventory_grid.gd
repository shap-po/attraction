extends GridContainer
class_name BaseInventoryGrid

@export var slot_scene: PackedScene
@export var inventory: BaseInventory
@onready var slots: Array[InventorySlot] = []

func _ready() -> void:
	setup()

func setup() -> void:
	if get_children().size() != 0:
		push_error("Invenotry grid cannot have child nodes!")
		for n in get_children():
			remove_child(n)
			n.queue_free()

	for s in range(inventory._content.size()):
		var slot: InventorySlot = slot_scene.instantiate()
		slots.append(slot)
		add_child(slot)

	update_slots()

## Should be overridden in the child class to return the correct inventory type
func get_inventory() -> BaseInventory:
	return inventory

func on_open() -> void:
	pass

func on_close() -> void:
	pass

func on_pressed(_index: int) -> void:
	pass

func _update_slot(index: int) -> void:
	var slot: InventorySlot = slots[index]
	var item: Item = inventory.get_item(index)
	update_slot(slot, item)

func update_slot(slot: InventorySlot, item: Item) -> void:
	if item == null:
		slot.item_texture.visible = false
		slot.item_price.visible = false
		slot.item_count.visible = false
		slot.button.tooltip_text = ""
		return

	slot.button.tooltip_text = item.item_name + '\n' + item.item_description

	slot.item_texture.visible = true
	slot.item_texture.texture = item.item_texture

func update_slots():
	for i in slots.size():
		_update_slot(i)
