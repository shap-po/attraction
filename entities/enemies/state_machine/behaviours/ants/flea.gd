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
	get_puppet().timer.wait_time = STUN_TIME
	get_puppet().timer.timeout.connect(stunned_timeout)
	get_puppet().timer.start()
	speed = puppet.speed * SPEED_MULTIPLIER
	if get_puppet().home:
		target_point = get_puppet().home.global_position
	else:
		var map_markers: Node2D = $/root/main/map/map_markers ## it has stupid
		var checkout_locations: Array[Node2D] = []
		puppet.unconditional_state = "ReturnForest"
		if !map_markers:
			#print("aw hell nah")
			return
		checkout_locations.clear()
		for child in map_markers.get_child(1).get_children(): ## its the fastest way possible, but prone to errors
			if child.visible == true:
				checkout_locations.append(child)
		puppet.target = checkout_locations[0]
		var dis1 = puppet.target.global_position.distance_squared_to(puppet.global_position)
		for loc in checkout_locations:
			var dis2 = loc.global_position.distance_squared_to(puppet.global_position)
			if dis1 < dis2: 
				puppet.target = loc
				dis1 = dis2
		target_point = puppet.target.global_position
		


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
