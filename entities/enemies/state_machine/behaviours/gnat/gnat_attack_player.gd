extends State
class_name GnatAttackPlayer

# OVERVIEW
# this behaviour will swarm the player and attack
# if player somehow lost, will revert to "GnatIdle"

@export var SPEED_MULTIPLIER: float = 1 * randf_range(0.9, 1.2)
@export var ROTATION_STRENGTH: float = 0.01 ## from 1.0 to 0.0
var cur_r: float = ROTATION_STRENGTH
var wait: float = 6

var speed: float
var target_point: Vector2

func on_creation() -> void:
	wait = 6
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.unconditional_state = "GnatIdle"
	if puppet.target == null:
		puppet.brain.force_transition("GnatAirborne")
		return

func procces(_delta: float) -> void:
	if puppet == null:
		return
	if puppet.target == null:
		puppet.brain.force_transition("GnatAirborne")
		return

	var target_vector: Vector2 = puppet.global_position.direction_to(puppet.target.global_position)
	var a: float = puppet.global_position.distance_squared_to(puppet.target.global_position)

	var b: float = puppet.velocity.angle()
	var c: float = target_vector.angle()
	var r: float = rad_to_deg(abs(b-c))

	var rmod: float = (r - 80) / 20
	if rmod < 0.01:
		rmod = 0.01
	if rmod > 0.2:
		rmod = 0.2

	var amod: float = a / 800
	if amod < 0.01:
		amod = 0.01
	if amod > 0.5:
		amod = 0.5

	if r < 90:
		if a < 2000:
			cur_r = 0.005
		else:
			cur_r = 0.1
	else:
		if a < 9000:
			cur_r = 0.005
		else:
			cur_r = 0.03

	@warning_ignore("narrowing_conversion")
	var smod: int = 4000 / a
	if smod < 1:
		smod = 1
	if smod > 2:
		smod = 2

	if cur_r > 1: cur_r = 1
	if cur_r < 0.0001: cur_r = 0.0001

	puppet.velocity = speed * smod * Vector2.RIGHT.rotated(lerp_angle(b, c, cur_r ))

	if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 200) && (smod > 1):
		puppet.melee(1)

	if not puppet.area_sight.overlaps_area(puppet.target.interaction_area):
		if wait <= 0:
			create_emote(Emote.EmoteType.QUESTION)
			puppet.target = null
		else:
			wait -= _delta * 1
	else:
		wait = 6
