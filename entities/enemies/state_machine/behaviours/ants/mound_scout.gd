extends State
class_name MoundScout

# OVERVIEW
# this behaviour will make mound preoritize workers over warriors
# and create warriors with "warrior_defend_base";
# create workers with "worker_scout" untill food is found or
# the hive is provoked

var time_next_state: float = 30

func get_puppet() -> AntMound:
	return puppet as AntMound

func on_creation() -> void:
	if not puppet is AntMound:
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return

	time_next_state = 30
	get_puppet().summon_chances = [0.5, 0.25, 0]
	get_puppet().brain_ant_killed.connect(on_ant_killed)

func exit() -> void:
	for child in get_puppet().ants.get_children():
		if child.has_method("take_damage"):
			child.brain.force_transition("Flea")
	if get_puppet().brain_ant_killed.is_connected(on_ant_killed):
		get_puppet().brain_ant_killed.disconnect(on_ant_killed)

func enter() -> void:
	pass

func procces(_delta: float) -> void:
	time_next_state -= _delta
	if time_next_state > 0:
		return

	if puppet.target == null or not puppet.target is Plant:
		puppet.target = Global.main.map_markers.plot_locations.pick_random()

	puppet.brain.force_transition("MoundRaid")

func on_ant_killed(type: Ant.AntType) -> void:
	if randf() < 0.5:
		return

	for child in get_puppet().ants.get_children():
		if child.has_method("take_damage"):
			if child.type == Ant.AntType.WORKER:
				child.brain.force_transition("Flea")

	get_puppet().brain.force_transition("MoundDefend")
