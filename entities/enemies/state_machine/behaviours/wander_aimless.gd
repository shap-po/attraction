extends State
class_name WanderAimless

# OVERVIEW
# this behaviour will choose random point around entity
# and move to it, after checking out the point -
# new one will be chosen

@export var SPEED_MULTIPLIER: float = 0.7
@export var DISTANCE_BASE: float = 100.0
@export var DISTANCE_SCATTER: float = 50.0
@export var CHECKOUT_PRECISION: float = 10.0
@export var WAIT_BASE: float = 3.0
@export var WAIT_SCATTER: float = 4.0
@export var TIMER_CYCLE: float = 0.25
var wait: float = -1.0

var speed: float
var target_point: Vector2

func on_creation() -> void:
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.timer.wait_time = TIMER_CYCLE
	puppet.timer.timeout.connect(clock)

func choose_new_point() -> void:
	if puppet == null:
		return
	target_point = puppet.global_position + Vector2(randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER), randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER)) + Vector2(pow(-1, randi_range(1, 2)) * DISTANCE_BASE, pow(-1, randi_range(1, 2)) * DISTANCE_BASE)
	if randf() < 0.1:
		wait = WAIT_BASE + randf_range(0, WAIT_SCATTER)


func enter() -> void:
	choose_new_point()

func exit() -> void:
	puppet.timer.timeout.disconnect(clock)

func procces(_delta: float) -> void:
	if puppet == null:
		return
	if wait >= 0.0:
		puppet.velocity = Vector2.ZERO
		return
	if puppet.global_position.distance_squared_to(target_point) < CHECKOUT_PRECISION:
		choose_new_point()
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)

func clock() -> void:
	if wait >= 0:
		wait -= 1.0 * TIMER_CYCLE
	
