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

func on_creation():
	if !(puppet is AntWorker): 
		push_warning("something initiated braincell of ant_worker without it actually being ant_worker.")
	puppet.timer.wait_time = STUN_TIME
	puppet.timer.timeout.connect(stunned_timeout)
	puppet.timer.start()
	speed = puppet.speed * SPEED_MULTIPLIER
	if puppet.home:
		target_point = puppet.home.global_position
	

func enter():
	create_emote(Emote.EmoteType.ALERT)
	

func procces():
	if puppet:
		if (stunned):
			puppet.velocity = Vector2.ZERO
			return
		if puppet.global_position.distance_to(target_point) < CHECKOUT_PRECISION:
			puppet.enter_home.emit(puppet.type)
			puppet.queue_free()
		puppet.velocity = speed * puppet.global_position.direction_to(target_point)
	pass

func stunned_timeout():
	stunned = false
