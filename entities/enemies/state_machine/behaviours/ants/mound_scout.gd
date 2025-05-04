extends State
class_name MoundScout

# OVERVIEW
# this behaviour will make mound preoritize workers over warriors
# and create warriors with "warrior_defend_base";
# create workers with "worker_scout" untill food is found or
# the hive is provoked

func get_puppet() -> AntMound:
	return puppet as AntMound

func on_creation() -> void:
	if !(puppet is AntMound):
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	get_puppet().summon_chances = [0.5, 0.5, 0]
	get_puppet().brain_ant_killed.connect(on_ant_killed)

func exit():
	if get_puppet().brain_ant_killed.is_connected(on_ant_killed):
		get_puppet().brain_ant_killed.disconnect(on_ant_killed)

func enter() -> void:
	pass

func procces(_delta) -> void:
	pass

func on_ant_killed(type: int):
	if randf() < 0.25:
		for child in get_puppet().ants.get_children():
			if child.type == 0:
				child.brain.force_transition("Flea")
		puppet.brain.force_transition("MoundDefend")
