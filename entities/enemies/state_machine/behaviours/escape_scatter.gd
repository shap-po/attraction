extends State
class_name escape_scatter

# OVERVIEW
# this behaviour will try to path to the escape,
# trying to avoid 

@export var SPEED_MULTIPLIER: float = 1.25
@export var DISTANCE_BASE: float = 100.0
@export var DISTANCE_SCATTER: float = 50.0
@export var CHECKOUT_PRECISION: float = 10.0


var speed: float
var target_point: Vector2

func on_creation():
	speed = puppet.speed * SPEED_MULTIPLIER

func choose_new_point():
	if !puppet:
		return
		
	var areas_in_sight: Array[Area2D] = puppet.area_sight.get_overlapping_areas()
	
	var area_to_avoid: Area2D = areas_in_sight.pop_front()
	if area_to_avoid == null:
		return
	else:
		pass
	
	
	target_point = puppet.global_position
	#kill me
	
func enter():
	choose_new_point()
	
func procces():
	if !puppet:
		return
	if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
		choose_new_point()
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)
