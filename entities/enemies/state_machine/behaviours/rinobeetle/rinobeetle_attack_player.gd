extends State
class_name RinobeetleAttackPlayer

@export var SPEED_MULTIPLIER: float = 1
var wait: float = 6
var smod: float = 1.0

var speed: float
var target_point: Vector2

func on_creation() -> void:
	wait = 6
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.unconditional_state = "RinobeetleAttackPlayer"
	if puppet.target == null:
		puppet.brain.force_transition("RinobeetleScout")
		return

func choose_point() -> void:
	target_point = (puppet.global_position.direction_to(puppet.target.global_position) * -50) + puppet.target.global_position

func procces(delta) -> void:
	if puppet == null:
		return
	if puppet.target == null:
		puppet.brain.force_transition("RinobeetleScout")
		return

	if target_point == null:
		choose_point()

	var dist: float = puppet.global_position.distance_squared_to(puppet.target.global_position)
	if dist < 4000 and dist > 500:
		puppet.brain.force_transition("RinobeetleCharge")
		return
	else:
		choose_point()

	puppet.velocity = speed * smod * puppet.global_position.direction_to(target_point)

	if dist < 150:
		puppet.melee(1)

	if puppet.target.get("interaction_area") and not puppet.area_sight.overlaps_area(puppet.target.interaction_area):
		if wait <= 0:
			create_emote(Emote.EmoteType.QUESTION)
			puppet.target = null
		else:
			wait -= delta
	else:
		wait = 6.0
