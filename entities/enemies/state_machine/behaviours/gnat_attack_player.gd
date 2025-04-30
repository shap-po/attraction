extends State
class_name GnatAttackPlayer

# OVERVIEW
# this behaviour will swarm the player and attack
# if player somehow lost, will revert to "FindFood"

@export var SPEED_MULTIPLIER: float = 1 * randf_range(0.9, 1.2)
@export var ROTATION_STRENGTH: float = 0.01 ## from 1.0 to 0.0
var cur_r: float = ROTATION_STRENGTH
var wait: int = -1

var speed: float
var target_point: Vector2

func on_creation() -> void:
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.unconditional_state = "GnatIdle"
	if !puppet.target:
		puppet.brain.force_transition("GnatAirborne")
	
	
	

func procces(_delta) -> void:
	if puppet == null:
		return
	if !puppet.target:
		puppet.brain.force_transition("GnatAirborne")
		return
	#puppet.look_at(puppet.target.global_position)
	
	var target_vector = puppet.global_position.direction_to(puppet.target.global_position)
	var a = puppet.global_position.distance_squared_to(puppet.target.global_position)
	
	#var target_vector = puppet.global_position.direction_to(Vector2.ZERO)
	#var a = puppet.global_position.distance_squared_to(Vector2.ZERO)
	
	var b = puppet.velocity.angle()
	var c = target_vector.angle()
	var r = rad_to_deg(abs(b-c))
	var rmod = (r - 80) / 20
	if rmod < 0.01: rmod = 0.01
	if rmod > 0.2: rmod = 0.2
	var amod  = a / 800
	if amod < 0.01: amod = 0.01
	if amod > 0.5: amod = 0.5
	var smod = 1

	if r < 90:
		if a < 2000: cur_r = 0.005
		else: cur_r = 0.1
	else:
		if a < 9000: cur_r = 0.005
		else: cur_r = 0.03
		
		
	smod = 4000 / a
	if smod < 1: smod = 1
	if smod > 2: smod = 2

	
	if cur_r > 1: cur_r = 1
	if cur_r < 0.0001: cur_r = 0.0001
	#print(' cur_r: ', cur_r, '| a: ', a, '| r: ', r, '| amod: ', amod, '| rmod: ', rmod)
	
	puppet.velocity = speed * smod * Vector2.RIGHT.rotated(lerp_angle(b, c, cur_r ))
	
	if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 1000) && (smod > 1):
		puppet.shoot(puppet.velocity.angle())
	
	if !puppet.area_sight.overlaps_area(puppet.target.interaction_area):
		#print(wait)
		if wait <= -1:
			wait = 200
		elif wait == 0:
			puppet.target = null
		else:
			wait -= 1
	else:
		#print(wait)
		wait = -1
		
