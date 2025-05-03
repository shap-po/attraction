extends AspectRatioContainer
class_name ItemButton

@onready var inventory_grid: InventoryGrid = get_parent()
@onready var item_visual: TextureRect = $button/itemTexture
@onready var item_price: Label = $button/itemPrice
@onready var item_count: Label = $button/itemCount
@onready var button: Button = $button

func hide_all_visuals() -> void:
	item_visual.visible = false
	item_price.visible = false
	item_count.visible = false

func unhide_all_visuals() -> void:
	item_visual.visible = true
	item_price.visible = true
	item_count.visible = true

func update(item: Item) -> void:
	if item == null:
		hide_all_visuals()
		return
	item_visual.visible = true
	item_visual.texture = item.item_texture

	if item.buy_price != 0:
		item_price.visible = true
		item_price.text = str(item.buy_price)
	else:
		item_price.visible = false

	if item is CountableItem:
		item_count.text = str(item.count)
		item_count.visible = true
	else:
		item_count.visible = false

func _on_button_toggled(_toggled_on: bool) -> void:
	inventory_grid.on_pressed(get_index())
