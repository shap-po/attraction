extends State
class_name RinobeetleAttackFood
var target_point


func on_creation() -> void:
	if puppet.target == null:
		puppet.brain.force_transition("RinobeetleScout")
		return

	puppet.unconditional_state = "RinobeetleAttackPlayer"
	choose_new_point()

func choose_new_point() -> void:
	target_point = puppet.target.global_position


func procces(_delta) -> void:
	if puppet.target == null:
		puppet.brain.force_transition("RinobeetleScout")
		return

	if puppet.global_position.distance_squared_to(target_point) < 500:
		puppet.velocity = 0.0001 * puppet.global_position.direction_to(target_point)
		puppet.melee(1)
		puppet.brain.hunger -= 1
		return

	puppet.velocity = puppet.speed * puppet.global_position.direction_to(target_point)

func on_damage_effect() -> void:
	puppet.unconditional_state = "RinobeetleAttackPlayer"
	puppet.brain.force_transition("RinobeetleScout")
