extends AspectRatioContainer
class_name InventorySlot

@onready var inventory_grid: BaseInventoryGrid = get_parent()
@onready var button: Button = $Button
@onready var item_content: Control = $Button/ItemContent
@onready var item_texture: TextureRect = $Button/ItemContent/ItemTexture
@onready var item_price: Label = $Button/ItemContent/ItemPrice
@onready var item_count: Label = $Button/ItemContent/ItemCount


func _on_button_pressed() -> void:
	inventory_grid.on_pressed(get_index())
