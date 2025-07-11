extends State
class_name WarriorDefendBase

# OVERVIEW
# warrior will try to patrol around the mound, if he has one
# if approached will warn and the attack
# if provoked will attack
# if whitnesses damage/kill will attack

@export var SPEED_MULTIPLIER: float = 0.7
@export var DISTANCE_BASE: float = 20
@export var DISTANCE_SCATTER: float = 5
@export var CHECKOUT_PRECISION: float = 10
@export var WAIT_BASE: float = 3.0
@export var WAIT_SCATTER: float = 4.0
@export var WAIT_CHANCE: float = 0.01
@export var TIMER_CYCLE: float = 0.25
@export var ORBIT_SPEED: float = 0.1 # in rads
var wait: float = -1.0

var speed: float
var target_point: Vector2
var orbit_angle

func get_puppet() -> AntWarrior:
	return puppet as AntWarrior

func on_creation() -> void:
	if not puppet is AntWarrior:
		push_warning("something initiated braincell of ant_warrior without it actually being ant_warrior.")
		return

	ORBIT_SPEED *= pow(-1, randi_range(1, 2))
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.timer.wait_time = TIMER_CYCLE
	puppet.timer.timeout.connect(clock)
	orbit_angle = deg_to_rad(randi_range(0, 360))
	choose_new_point()
	puppet.unconditional_state = "WarriorDefendBase"


func choose_new_point() -> void:
	if puppet == null:
		return
	if get_puppet().home == null:
		puppet.brain.force_transition("WarriorLinger")
		return
	orbit_angle += ORBIT_SPEED
	target_point = get_puppet().home.global_position + Vector2(DISTANCE_BASE, 0).rotated(orbit_angle) + Vector2(randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER), randf_range(-DISTANCE_SCATTER, DISTANCE_SCATTER))

	if randf() < WAIT_CHANCE:
		wait = WAIT_BASE + randf_range(0, WAIT_SCATTER)


func procces(_delta: float) -> void:
	if puppet == null:
		return

	var find: Puppet.FindType = puppet.check_area()
	if find == Puppet.FindType.PLAYER:
		puppet.brain.force_transition("WarriorProtect")
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

func exit() -> void:
	if get_puppet().timer.timeout.is_connected(clock):
		get_puppet().timer.timeout.disconnect(clock)

func on_alerted(pos: Vector2) -> void:
	var find: Puppet.FindType = puppet.check_area()
	puppet.unconditional_state = "WarriorRage"
	if (find == puppet.FindType.PLAYER):
		puppet.brain.force_transition("WarriorRage")
		return

	create_emote(Emote.EmoteType.WARNING)
	puppet.brain.force_transition("WarriorLinger")
	if pos != Vector2.ZERO:
		puppet.brain.current_state.target_point = pos
