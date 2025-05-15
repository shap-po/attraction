extends State
class_name EscapeScatter

# OVERVIEW
# this behaviour will try to path to the escape,
# trying to avoid 

@export var SPEED_MULTIPLIER: float = 1.25
@export var DISTANCE_BASE: float = 100.0
@export var DISTANCE_SCATTER: float = 50.0
@export var CHECKOUT_PRECISION: float = 10.0
var speed: float
var target_point: Vector2

func on_creation() -> void:
	speed = puppet.speed * SPEED_MULTIPLIER

func choose_new_point() -> void:
	if puppet == null:
		return

	var areas_in_sight: Array[Area2D] = puppet.area_sight.get_overlapping_areas()

	var area_to_avoid: Area2D = areas_in_sight.pop_front()
	if area_to_avoid == null:
		return
	else:
		pass

	target_point = puppet.global_position

func enter() -> void:
	choose_new_point()

func procces(_delta: float) -> void:
	if puppet == null:
		return
	if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
		choose_new_point()
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)
