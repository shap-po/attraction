extends State
class_name WorkerScout

# OVERVIEW
# worker will try to wander towards food, if it finds it
# ant will return to base
# if approached will flea
# if whitnesses damage/kill will hide

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

func on_creation():
	if !(puppet is AntWorker): 
		push_error("something initiated braincell of ant_worker without it actually being ant_worker.")
		return
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.timer.wait_time = TIMER_CYCLE
	puppet.timer.timeout.connect(clock)

func choose_new_point():
	if !puppet:
		return
	target_point = puppet.global_position + Vector2(randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER), randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER)) + Vector2(pow(-1, randi_range(1,2)) * DISTANCE_BASE, pow(-1, randi_range(1,2)) * DISTANCE_BASE) 
	var roll = randf()
	if roll < 0.1:
		wait = (WAIT_BASE + randf_range(0, WAIT_SCATTER))
	
func exit():
	puppet.timer.timeout.disconnect(clock)
	
func enter():
	choose_new_point()
	
func procces():
	if puppet:
		if wait >= 0.0:
			puppet.velocity = Vector2.ZERO
			return
		if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
			choose_new_point()
		puppet.velocity = speed * puppet.global_position.direction_to(target_point)
	pass

func clock():
	if wait >= 0:
		wait -= 1.0 * TIMER_CYCLE
	
