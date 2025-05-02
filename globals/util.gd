class_name Util

static func enum_to_str(enum_def: Dictionary, value: int) -> String:
	for key in enum_def.keys():
		if enum_def[key] == value:
			return key
	return ""

## Removes all elements that are in the second array from the first one
static func remove_array(array: Array, values: Array) -> void:
	var pos: int
	for val in values:
		pos = array.find(val)
		if pos != -1:
			array.pop_at(pos)
