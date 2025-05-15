extends State
class_name GnatAirborne

# OVERVIEW
# this is a transit behaviour; does nothing meaningfull on its own

var scale_mod: float = 1
var n_state: String

func on_creation() -> void:
	puppet.brain.block_transitions = true
	n_state = puppet.unconditional_state

	if n_state == "GnatIdle":
		scale_mod = 1
	if n_state == "GnatAttackPlayer":
		scale_mod = 0.7

func procces(_delta: float) -> void:
	if n_state == "GnatIdle":
		scale_mod -= 0.01
	if n_state == "GnatAttackPlayer":
		scale_mod += 0.005

	puppet.scale = Vector2(1, 1) * scale_mod
	if scale_mod >= 1 and n_state == "GnatAttackPlayer":
		scale_mod = 1.01
		next_state()
		return

	if scale_mod <= 0.7 and n_state == "GnatIdle":
		scale_mod = 0.69
		next_state()
		return

func next_state() -> void:
	if n_state == "GnatAttackPlayer":
		create_emote(Emote.EmoteType.ALERT)

	puppet.brain.block_transitions = false
	puppet.brain.force_transition(n_state)
