@tool
extends BaseInventoryGrid
class_name PlayerInventoryGrid

var selected_slot: int = -1

func _ready() -> void:
	super._ready()

	get_inventory().on_content_changed.connect(update_slot)

func _process(_delta: float) -> void:
	if selected_slot == -1:
		return

	slots[selected_slot].item_content.global_position = get_global_mouse_position()

func get_inventory() -> PlayerInventory:
	return inventory as PlayerInventory

func on_close() -> void:
	super.on_close()
	if selected_slot != -1:
		slots[selected_slot].reset_content_position()
		selected_slot = -1

func on_pressed(index: int) -> void:
	super.on_pressed(index)
	if selected_slot == -1:
		# do not allow selecting an empty slot first
		if inventory.get_item(index) == null:
			return

		selected_slot = index
		return

	if selected_slot == index:
		slots[selected_slot].reset_content_position()
		selected_slot = -1
		return

	slots[selected_slot].reset_content_position()
	get_inventory().swap_slots(selected_slot, index)
	selected_slot = -1


func _validate_property(property: Dictionary) -> void:
	# override inventory type hint
	if property.name == "inventory":
		property.hint_string = "PlayerInventory"
