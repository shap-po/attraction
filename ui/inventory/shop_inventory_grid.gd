extends BaseInventoryGrid
class_name ShopInventoryGrid

@export var player_inventory: PlayerInventory

func _ready() -> void:
	super._ready()

func on_pressed(index: int) -> void:
	super.on_pressed(index)

	var item: Item = inventory.get_item(index)
	if item == null:
		return

	buy_item(item)

func buy_item(item: Item) -> bool:
	if Global.main.money_manager.value - item.buy_price < 0:
		return false

	var res: bool = player_inventory.add_item(item.duplicate())
	if res:
		Global.main.money_manager.remove(item.buy_price)

	return res

func update_slot(slot: InventorySlot, item: Item) -> void:
	super.update_slot(slot, item)
	if item == null:
		return

	slot.item_count.visible = false
	slot.item_price.add_theme_color_override("font_color", Color(0.9, 0.9, 0.0))

	# update price
	slot.item_price.visible = true
	slot.item_price.text = str(item.buy_price)
