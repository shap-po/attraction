extends State
class_name ReturnForest

@export var SPEED_MULTIPLIER: float = 0.7
var target_point: Vector2

func on_creation() -> void:
	puppet.unconditional_state = "ReturnForest"
	if puppet == null:
		return

	choose_new_point()

func choose_new_point() -> void:
	puppet.target = Util.get_closest_node(puppet, Global.main.map_markers.forest_locations)
	if puppet.target == null:
		return

	target_point = puppet.target.global_position


func procces(_delta: float) -> void:
	if target_point.distance_squared_to(puppet.global_position) < 50:
		puppet.target = null
		puppet.queue_free()
		return

	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)
