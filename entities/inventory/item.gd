extends Resource
class_name Item

@export var item_name: String = ""
@export var item_texture: Texture2D
@export_multiline var item_description: String = ""
@export_range(0, 99999999) var buy_price: int = 0
@export_range(0, 99999999) var sell_price: int = 0

func equals(other: Item) -> bool:
	if other == null:
		return false

	for property in get_property_list():
		if property.name == "count":
			continue
		var value = self.get(property.name)
		var other_value = other.get(property.name)

		if value != other_value:
			return false

	return true

func create_world_item() -> WorldItem:
	return WorldItem.create(self.duplicate())

func _to_string() -> String:
	return item_name + ":type=" + get_class() + ":buy=" + str(buy_price) + ":sell=" + str(sell_price)
