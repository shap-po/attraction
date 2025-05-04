extends State
class_name WarriorRage
# OVERVIEW


@export var SPEED_MULTIPLIER: float = 1.2 * randf_range(0.95, 1.1)
var wait: float = -1

var speed: float
var target_point: Vector2

func on_creation() -> void:
	speed = puppet.speed * SPEED_MULTIPLIER
	if !puppet.target:
		puppet.brain.force_transition("WarriorLinger")
	create_emote(Emote.EmoteType.ANGRY)
	
func choose_new_point() -> void:
	if puppet == null:
		return
	target_point = puppet.target.global_position + Vector2(randf_range(-3, 3), randf_range(-3, 3))

func procces(_delta) -> void:
	if puppet == null:
		return
	if !puppet.target:
		puppet.brain.force_transition("WarriorLinger")
		return
		
	
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)

	if (puppet.target.global_position.distance_squared_to(target_point) > 2000):
		choose_new_point()

	if (puppet.global_position.distance_squared_to(target_point) < 200):
		choose_new_point()

	if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 200):
		puppet.melee(1)

	if !puppet.area_sight.overlaps_area(puppet.target.interaction_area):
		#print(wait)
		if wait <= 0:
			create_emote(Emote.EmoteType.QUESTION)
			puppet.target = null
		else:
			wait -= _delta * 1
	else:
		wait = 6

func on_alerted(cause):
	puppet.unconditional_state = "WarriorRage"
