extends State
class_name MoundScout

# OVERVIEW
# this behaviour will make mound preoritize workers over warriors
# and create warriors with "warrior_defend_base";
# create workers with "worker_scout" untill food is found or
# the hive is provoked

@onready var map_markers: Node2D = $/root/main/map/map_markers ## it has stupid
var time_next_state: float = 30
var checkout_locations: Array[Node2D] = []

func get_puppet() -> AntMound:
	return puppet as AntMound

func on_creation() -> void:
	if !(puppet is AntMound):
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	time_next_state = 30
	get_puppet().summon_chances = [0.5, 0.25, 0]
	get_puppet().brain_ant_killed.connect(on_ant_killed)

	if !map_markers:
		#print("aw hell nah")
		return
	checkout_locations.clear()
	for child in map_markers.get_child(0).get_children():
		if child.visible == true:
			checkout_locations.append(child)

func exit():
	for child in get_puppet().ants.get_children():
		if child.has_method("take_damage"):
			child.brain.force_transition("Flea")
	if get_puppet().brain_ant_killed.is_connected(on_ant_killed):
		get_puppet().brain_ant_killed.disconnect(on_ant_killed)

func enter() -> void:
	pass

func procces(_delta) -> void:
	time_next_state -= _delta
	if time_next_state <= 0:
		if not get_puppet().target and get_puppet().target is Plant:
			var target_loc
			var dis1 = puppet.target.global_position.distance_squared_to(puppet.global_position)
			for loc in checkout_locations:
				var dis2 = loc.global_position.distance_squared_to(puppet.global_position)
				if dis1 < dis2:
					target_loc = loc
					dis1 = dis2
			puppet.target = target_loc
		else:
			puppet.target = checkout_locations.pick_random()
		get_puppet().brain.force_transition("MoundRaid")

func on_ant_killed(type: int):
	if randf() < 0.5:
		for child in get_puppet().ants.get_children():
			if child.has_method("take_damage"):
				if child.type == 0:
					child.brain.force_transition("Flea")
		get_puppet().brain.force_transition("MoundDefend")
