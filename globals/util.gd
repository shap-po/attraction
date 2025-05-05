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

## Recursively removes node and all its children from the tree
static func remove_node(node: Node) -> void:
	if node == null:
		return
	for child in node.get_children():
		remove_node(child)
	node.queue_free()
