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

## Sorts the array by distance to the given node in descending order
## Note: Elements in the array must extend Node2D
static func sort_by_distance_des(node: Node2D, array: Array) -> void:
	array.sort_custom(func(a: Node2D, b: Node2D): return node.global_position.distance_squared_to(a.global_position) > node.global_position.distance_squared_to(b.global_position))

## Sorts the array by distance to the given node in ascending order
## Note: Elements in the array must extend Node2D
static func sort_by_distance_asc(node: Node2D, array: Array) -> void:
	array.sort_custom(func(a: Node2D, b: Node2D): return node.global_position.distance_squared_to(a.global_position) < node.global_position.distance_squared_to(b.global_position))

## Returns the closest node to the given one from the array
## Note: Elements in the array must extend Node2D
static func get_closest_node(node: Node2D, array: Array) -> Node2D:
	if array.size() == 0:
		return null
	if array.size() == 1:
		return array[0]

	var closest: Node2D = array[0]
	var closest_distance: float = node.global_position.distance_squared_to(closest.global_position)

	for element in array:
		var distance: float = node.global_position.distance_squared_to(element.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = element

	return closest
