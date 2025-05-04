extends State
class_name RinobeetleCharge

var wait: int = -1
var smod: float = 1.0

var speed: float
var target_direction: Vector2

func on_creation() -> void:
	wait = 0.75
	smod = 6
	puppet.unconditional_state = "RinobeetleAttackPlayer"
	puppet.velocity = Vector2.ZERO
	create_emote(Emote.EmoteType.WARNING)
	if !puppet.target:
		puppet.brain.force_transition("RinobeetleScout")
	choose_direction()

func choose_direction():
	target_direction = puppet.global_position.direction_to(puppet.target.global_position)

func procces(_delta: float) -> void:
	print(wait)

	if wait > 0:
		wait -= _delta
		return

	if smod <= 1:
		puppet.brain.force_transition("RinobeetleAttackPlayer")
	else:
		smod -= _delta * 4

	speed = puppet.speed * smod
	puppet.velocity = speed * target_direction

	var bodies: Array[Node2D] = puppet.area_touch.get_overlapping_bodies()
	bodies.remove_at(0)
	if bodies:
		print(bodies)
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(3)
			if body.has_method("apply_stun"):
				body.apply_stun(1)

			puppet.take_damage(1)
			puppet.apply_stun(2.5)
			exit()
			return

func exit():
	puppet.velocity = Vector2.ZERO
