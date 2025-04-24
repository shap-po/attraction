extends Resource
class_name Item

enum ItemType {
	DEFAULT = -1, ## Set the type based based on the inherited class
	WEAPON,
	SEED,
	CROP
}

@export var item_name: String = ""
@export var item_texture: Texture2D
@export_multiline var item_description: String = ""
@export var item_type: ItemType = ItemType.DEFAULT
@export_range(0, 99999999) var buy_price: int = 0
@export_range(0, 99999999) var sell_price: int = 0
