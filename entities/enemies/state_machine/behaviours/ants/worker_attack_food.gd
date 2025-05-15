extends State
class_name WorkerAttackFood

var target_point: Vector2


func on_creation() -> void:
	if puppet.target == null:
		puppet.brain.force_transition("WorkerScout")
		return
	puppet.unconditional_state = "Flee"
	choose_new_point()

func choose_new_point() -> void:
	target_point = puppet.target.global_position

func procces(_delta) -> void:
	if puppet.target == null:
		if puppet.brain.hunger <= 0:
			puppet.brain.force_transition("Flea")
			return
		puppet.brain.force_transition("WorkerScout")
		return

	puppet.velocity = puppet.speed * puppet.global_position.direction_to(target_point)

	if puppet.global_position.distance_squared_to(target_point) < 500:
		puppet.velocity = 0.0001 * puppet.global_position.direction_to(target_point)
		puppet.melee(1)
		puppet.brain.hunger -= 1
		return


func on_alerted(pos: Vector2) -> void:
	create_emote(Emote.EmoteType.ALERT)
	puppet.unconditional_state = "Flea"
	puppet.brain.force_transition("Flea")
