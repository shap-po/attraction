extends State
class_name WarriorLinger

# OVERVIEW
# this behaviour will choose random point around entity
# and move to it, after checking out the point -
# new one will be chosen

@export var SPEED_MULTIPLIER: float = 0.7
@export var DISTANCE_BASE: float = 20.0
@export var DISTANCE_SCATTER: float = 20.0
@export var CHECKOUT_PRECISION: float = 10.0
@export var WAIT_BASE: float = 1.0
@export var WAIT_SCATTER: float = 1.0
var wait: float = -1.0
@export var time_next_state: float = 13
var speed: float
var target_point: Vector2

func on_creation() -> void:
	if puppet.unconditional_state == "WarriorLinger":
		puppet.unconditional_state = "Flea"
	if puppet.unconditional_state == "WarriorRage":
		puppet.unconditional_state = "Flea"

	time_next_state = 10
	speed = puppet.speed * SPEED_MULTIPLIER

func choose_new_point() -> void:
	if puppet == null:
		return

	target_point = puppet.global_position + Vector2(randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER), randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER)) + Vector2(pow(-1, randi_range(1, 2)) * DISTANCE_BASE, pow(-1, randi_range(1, 2)) * DISTANCE_BASE)
	if randf() < 0.1:
		wait = (WAIT_BASE + randf_range(0, WAIT_SCATTER))


func enter() -> void:
	if target_point == null: choose_new_point()

func procces(_delta: float) -> void:
	if puppet == null:
		return

	clock(_delta)
	if wait >= 0.0:
		puppet.velocity = Vector2.ZERO
		return

	var find: Puppet.FindType = puppet.check_area()
	if find == Puppet.FindType.PLAYER:
		if puppet.unconditional_state == "WarriorRage":
			puppet.brain.force_transition("WarriorRage")
		else:
			puppet.brain.force_transition("WarriorProtect")
		return

	if puppet.global_position.distance_squared_to(target_point) < CHECKOUT_PRECISION:
		choose_new_point()
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)


func clock(delta: float) -> void:
	if time_next_state >= 0:
		time_next_state -= delta
	else:
		puppet.brain.force_transition(puppet.unconditional_state)
	if wait >= 0:
		wait -= delta

func on_alerted(_pos: Vector2) -> void:
	puppet.unconditional_state = "WarriorRage"
	var find: Puppet.FindType = puppet.check_area()
	if find == puppet.FindType.PLAYER:
		puppet.brain.force_transition("WarriorRage")
