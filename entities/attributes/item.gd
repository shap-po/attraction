extends Resource
class_name Item

enum ItemType {
	DEFAULT = -1, ## Set the type based based on the inherited class
	WEAPON,
	SEED,
	CROP
}

@export var texture: Texture2D
@export var name: String
@export_multiline var description: String
@export var item_type: ItemType = ItemType.DEFAULT

@export_range(0, 99999999)
var buy_price: int

@export_range(0, 99999999)
var sell_price: int
