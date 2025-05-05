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
	if !puppet.target:
		puppet.brain.force_transition("RinobeetleScout")


func choose_point():
	target_point = (puppet.global_position.direction_to(puppet.target.global_position) * -50) + puppet.target.global_position

#target_point = puppet.target.global_position


func procces(delta) -> void:
	if puppet == null:
		return
	if !puppet.target:
		puppet.brain.force_transition("RinobeetleScout")
		return
	if !target_point:
		choose_point()

	if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 4000) and (puppet.global_position.distance_squared_to(puppet.target.global_position) > 500):
		puppet.brain.force_transition("RinobeetleCharge")
	else:
		choose_point()

	puppet.velocity = speed * smod * puppet.global_position.direction_to(target_point)

	if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 150):
		puppet.melee(1)

	if !puppet.area_sight.overlaps_area(puppet.target.interaction_area):
		#print(wait)
		if wait <= 0:
			create_emote(Emote.EmoteType.QUESTION)
			puppet.target = null
		else:
			wait -= delta
	else:
		#print(wait)
		wait = 6.0
		
