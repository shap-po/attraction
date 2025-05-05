extends State
class_name WarriorEscort


@export var SPEED_MULTIPLIER: float = 1.45 * randf_range(0.95, 1.1)
var speed
var target_point
var protection_target = null

func on_creation():
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.unconditional_state = "WarriorEscort"
	choose_new_point()
	if !puppet.target:
		puppet.brain.force_transition("WarriorLinger")
	puppet.velocity = Vector2.ZERO

func choose_new_point() -> void:
	if puppet == null:
		return
	if protection_target == null:
		var bodies: Array[Node2D] = puppet.area_sight.get_overlapping_bodies()
		bodies.remove_at(0)
		var list = []
		if bodies:
			for body in bodies:
				if body is AntWorker:
					list.append(body)
		puppet.target = list.pick_random()
		if puppet.target is AntWorker:
			protection_target = puppet.target

	if (target_point == null) and (protection_target != null):
		target_point = protection_target.global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))


func procces(_delta):
	#print("d: ",target_point, " ", puppet.global_position)
	if (protection_target == null):
		choose_new_point()
		if protection_target == null:
			puppet.brain.force_transition("WarriorLinger")
	if puppet.global_position.distance_squared_to(target_point) < 100:
		target_point = null
		choose_new_point()

	var find: Puppet.FindType = puppet.check_area()
	if find == Puppet.FindType.PLAYER:
		if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 1400):
			puppet.brain.force_transition("WarriorRage")
			return

	if target_point == null:
		return
	puppet.velocity = speed * puppet.global_position.direction_to(target_point)
	#puppet.global_position = target_point


func on_alerted(pos):
	var find = puppet.check_area()
	puppet.unconditional_state = "WarriorRage"
	if (find == puppet.FindType.PLAYER):
		puppet.brain.force_transition("WarriorRage")
