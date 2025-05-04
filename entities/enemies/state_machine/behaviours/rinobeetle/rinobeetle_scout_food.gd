extends State
class_name RinobeetleScout

@export var SPEED_MULTIPLIER: float = 0.7
var target_point: Vector2
@onready var map_markers: Node2D = $/root/main/map/map_markers ## it has stupid
var checkout_locations: Array[Marker2D] = []


func on_creation() -> void:
	var marker_index: int = 0
	if puppet.unconditional_state == "RinobeetleAttackPlayer":
		marker_index = 3
	if !map_markers:
		#print("aw hell nah")
		return
	checkout_locations.clear()
	for child in map_markers.get_child(marker_index).get_children():
		if child.visible == true:
			checkout_locations.append(child)
	if puppet == null:
		return
	choose_new_point()

func choose_new_point() -> void:
	if puppet.target == null:
		puppet.target = checkout_locations.pick_random()
	target_point = puppet.target.global_position


func procces(_delta) -> void:
	var find: Puppet.FindType
	if puppet.unconditional_state == "RinobeetleAttackPlayer": find = puppet.check_area()
	else: find = puppet.check_area(Puppet.FindType.PLANT)


	if find == puppet.FindType.PLAYER and puppet.unconditional_state == "RinobeetleAttackPlayer":
		puppet.brain.force_transition("RinobeetleAttackPlayer")
		return
	if find == puppet.FindType.PLANT and puppet.unconditional_state == "RinobeetleAttackFood":
		puppet.brain.force_transition("RinobeetleAttackFood")
		return
	if !target_point:
		return
	if target_point.distance_squared_to(puppet.global_position) < 50:
		puppet.target = null
		if randf() < 0.1:
			choose_new_point()
		else:
			puppet.brain.force_transition("RinobeetleIdle")
	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)

func on_damage_effect():
	create_emote(Emote.EmoteType.ANGRY)
	puppet.unconditional_state = "RinobeetleAttackPlayer"
