extends State
class_name Flea

# OVERVIEW
# worker will hide in the mound, if it has one, otherwise will run to the forest

@export var SPEED_MULTIPLIER: float = 1.5
@export var CHECKOUT_PRECISION: float = 1
@export var STUN_TIME: float = 0.5
var speed: float
var stunned: bool = true
var target_point: Vector2

func get_puppet() -> Ant:
	return puppet as Ant

func on_creation() -> void:
	puppet.timer.wait_time = STUN_TIME
	puppet.timer.timeout.connect(stunned_timeout)
	puppet.timer.start()
	speed = puppet.speed * SPEED_MULTIPLIER

	if get_puppet().home:
		target_point = get_puppet().home.global_position
		return

	puppet.unconditional_state = "ReturnForest"

	# find the closest forest location
	puppet.target = Util.get_closest_node(puppet, Global.main.map_markers.forest_locations)
	if puppet.target == null:
		return

	target_point = puppet.target.global_position

func procces(_delta: float) -> void:
	if puppet == null:
		return
	if stunned:
		puppet.velocity = Vector2.ZERO
		return

	if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
		get_puppet().enter_home.emit(get_puppet())
		puppet.queue_free()
		return

	puppet.velocity = speed * puppet.global_position.direction_to(target_point)

func stunned_timeout() -> void:
	stunned = false
	puppet.timer.timeout.disconnect(stunned_timeout)
