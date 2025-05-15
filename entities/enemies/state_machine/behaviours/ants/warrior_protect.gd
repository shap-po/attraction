extends State
class_name WarriorProtect

@export var SPEED_MULTIPLIER: float = 0.1
var wait: float = 4

func get_puppet() -> AntWarrior:
	return puppet as AntWarrior

func on_creation():
	if puppet.unconditional_state == "NoAi": puppet.unconditional_state = "WarriorLinger"
	if puppet.target == null:
		puppet.brain.force_transition(puppet.unconditional_state)
	puppet.unconditional_state = "WarriorLinger"
	puppet.velocity = Vector2.ZERO

func procces(_delta: float) -> void:
	if puppet == null:
		return
	if puppet.target == null:
		puppet.brain.force_transition(puppet.unconditional_state)
		return

	get_puppet().sprite.look_at(puppet.target.global_position)

	if puppet.global_position.distance_squared_to(puppet.target.global_position) < 2500:
		puppet.brain.force_transition("WarriorRage")
		return

func exit():
	get_puppet().sprite.rotation = 0

func on_alerted(pos: Vector2) -> void:
	puppet.unconditional_state = "WarriorRage"
	puppet.brain.force_transition("WarriorRage")
