extends State
class_name SnailScoutFood

@export var SPEED_MULTIPLIER: float = 0.7
var target_point: Vector2

func on_creation() -> void:
	puppet.unconditional_state = "SnailScoutFood"
	if puppet == null:
		return

	choose_new_point()

func choose_new_point() -> void:
	if puppet.target == null:
		puppet.target = Global.main.map_markers.plot_locations.pick_random()
	target_point = puppet.target.global_position

func procces(_delta: float) -> void:
	var find: Puppet.FindType = puppet.check_area(Puppet.FindType.PLAYER)
	if find == Puppet.FindType.PLANT:
		puppet.brain.force_transition("SnailAttackFood")
		return
	if not target_point:
		return

	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)
