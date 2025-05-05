extends Item
class_name CountableItem

@export var count: int = 1

func _to_string() -> String:
	return super._to_string() + ":count=" + str(count)
