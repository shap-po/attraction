extends State
class_name GnatTravel

@export var SPEED_MULTIPLIER: float = 0.7
var target_point: Vector2


func on_creation() -> void:
	puppet.unconditional_state = "GnatAttackPlayer"
	if puppet == null:
		return

	choose_new_point()

func choose_new_point() -> void:
	if puppet.target == null:
		puppet.target = Global.main.map_markers.plot_locations.pick_random()
	target_point = puppet.target.global_position + Vector2(randf_range(-25, 25), randf_range(-25, 25))

func procces(_delta: float) -> void:
	var find: Puppet.FindType = puppet.check_area(Puppet.FindType.PLAYER)
	if find == Puppet.FindType.PLAYER:
		puppet.brain.force_transition("GnatAttackPlayer")
		return
	if not target_point:
		return
	if target_point.distance_squared_to(puppet.global_position) < 50:
		puppet.target = null
		puppet.unconditional_state = "GnatIdle"
		puppet.brain.force_transition("GnatAirborne")
		return
	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)
