extends AspectRatioContainer
class_name InventorySlot

@onready var inventory_grid: BaseInventoryGrid = get_parent()
@onready var button: Button = $Button
@onready var item_content: Control = $Button/ItemContent
@onready var item_texture: TextureRect = $Button/ItemContent/ItemTexture
@onready var item_price: Label = $Button/ItemContent/ItemPrice
@onready var item_count: Label = $Button/ItemContent/ItemCount


func hide_all_visuals() -> void:
	item_texture.visible = false
	item_price.visible = false
	item_count.visible = false

func unhide_all_visuals() -> void:
	item_texture.visible = true
	item_price.visible = true
	item_count.visible = true

func update(item: Item) -> void:
	if item == null:
		hide_all_visuals()
		return

	item_texture.visible = true
	item_texture.texture = item.item_texture

	update_price(item)
	update_count(item)

func update_price(item: Item) -> void:
	if item.sell_price != 0:
		item_price.visible = true
		item_price.text = str(item.sell_price)
	else:
		item_price.visible = false

func update_count(item: Item) -> void:
	if item is CountableItem:
		item_count.text = str(item.count)
		item_count.visible = true
	else:
		item_count.visible = false

func _on_button_pressed() -> void:
	inventory_grid.on_pressed(get_index())
