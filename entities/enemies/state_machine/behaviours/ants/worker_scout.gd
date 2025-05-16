extends State
class_name WorkerScout

# OVERVIEW
# worker will try to wander towards food, if it finds it
# ant will return to base
# if approached will flea
# if whitnesses damage/kill will hide

@export var SPEED_MULTIPLIER: float = 0.7
@export var DISTANCE_BASE: float = 100.0
@export var DISTANCE_BIAS: float = 60.0
@export var DISTANCE_BIAS_MIN: float = 62500.0
@export var DISTANCE_SCATTER: float = 50.0
@export var CHECKOUT_PRECISION: float = 10.0
@export var WAIT_BASE: float = 3.0
@export var WAIT_SCATTER: float = 4.0
@export var TIMER_CYCLE: float = 0.25
var wait: float = -1.0

var speed: float
var target_point: Vector2

func get_puppet() -> AntWorker:
	return puppet as AntWorker

func on_creation() -> void:
	if not puppet is AntWorker:
		push_error("something initiated braincell of ant_worker without it actually being ant_worker.")
		return
	choose_new_point()
	speed = puppet.speed * SPEED_MULTIPLIER
	get_puppet().timer.wait_time = TIMER_CYCLE
	get_puppet().timer.timeout.connect(clock)

func choose_new_point() -> void:
	if puppet == null:
		return
	target_point = puppet.global_position + Vector2(randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER), randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER)) + Vector2(pow(-1, randi_range(1, 2)) * DISTANCE_BASE, pow(-1, randi_range(1, 2)) * DISTANCE_BASE)
	# add bias twoards center of the plots
	if puppet.global_position.distance_squared_to(Global.main.map_markers.scout_ants_bias.global_position) > DISTANCE_BIAS_MIN:
		target_point += puppet.global_position.direction_to(Global.main.map_markers.scout_ants_bias.global_position) * DISTANCE_BIAS
	if randf() < 0.1:
		wait = (WAIT_BASE + randf_range(0, WAIT_SCATTER))

func exit() -> void:
	if get_puppet().timer.timeout.is_connected(clock):
		get_puppet().timer.timeout.disconnect(clock)

func procces(_delta: float) -> void:
	if puppet == null:
		return

	if wait >= 0.0:
		puppet.velocity = Vector2.ZERO
		return

	var find: Puppet.FindType = puppet.check_area(Puppet.FindType.PLANT)
	if find == Puppet.FindType.PLANT:
		if get_puppet().home == null:
			puppet.brain.force_transition("WorkerAttackFood")
			return
		puppet.get_parent().get_parent().target = puppet.target
		puppet.brain.force_transition("Flea")
		return

	if puppet.global_position.distance_squared_to(target_point) < CHECKOUT_PRECISION:
		choose_new_point()
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)


func clock() -> void:
	if wait >= 0:
		wait -= 1.0 * TIMER_CYCLE

func on_alerted(_pos: Vector2) -> void:
	create_emote(Emote.EmoteType.ALERT)
	puppet.unconditional_state = "Flea"
	puppet.brain.force_transition("Flea")
