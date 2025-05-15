extends State
class_name SnailAttackFood

# OVERVIEW
# will simply approach food and attack it
# if disturbed will transfer to "snail_hide"

var target_point: Vector2


func on_creation() -> void:
	if puppet.target == null:
		puppet.brain.force_transition("SnailScoutFood")
		return
	puppet.unconditional_state = "SnailAttackFood"
	choose_new_point()

func choose_new_point() -> void:
	target_point = puppet.target.global_position

func procces(_delta) -> void:
	if puppet.target == null:
		if puppet.brain.hunger <= 0:
			puppet.unconditional_state = "ReturnForest"
			puppet.brain.force_transition("ReturnForest")
			return
		puppet.brain.force_transition("SnailScoutFood")

	if puppet.global_position.distance_squared_to(target_point) < 500:
		puppet.velocity = 0.0001 * puppet.global_position.direction_to(target_point)
		puppet.melee(1)
		puppet.brain.hunger -= 1
		return

	puppet.velocity = puppet.speed * puppet.global_position.direction_to(target_point)
