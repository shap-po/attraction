extends State
class_name Flea

# OVERVIEW
# worker will hide in the mound, if it has one

@export var SPEED_MULTIPLIER: float = 1.5
@export var CHECKOUT_PRECISION: float = 1
@export var STUN_TIME: float = 0.5
var speed: float
var stunned: bool = true
var target_point: Vector2

func get_puppet() -> Ant:
	return puppet as Ant

func on_creation() -> void:
	if !(puppet is AntWorker):
		push_warning("something initiated braincell of ant_worker without it actually being ant_worker.")
	get_puppet().timer.wait_time = STUN_TIME
	get_puppet().timer.timeout.connect(stunned_timeout)
	get_puppet().timer.start()
	speed = puppet.speed * SPEED_MULTIPLIER
	if get_puppet().home:
		target_point = get_puppet().home.global_position


func enter() -> void:
	create_emote(Emote.EmoteType.ALERT)

	
func procces(_delta) -> void:
	if puppet:
		if (stunned):
			puppet.velocity = Vector2.ZERO
			return
		if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
			get_puppet().enter_home.emit(get_puppet().type)
			puppet.queue_free()
		puppet.velocity = speed * puppet.global_position.direction_to(target_point)
	pass

func stunned_timeout() -> void:
	stunned = false
	get_puppet().timer.timeout.disconnect(stunned_timeout)
