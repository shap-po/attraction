extends State
class_name MoundDefend

var wait: float = 20

func get_puppet() -> AntMound:
	return puppet as AntMound

func on_creation() -> void:
	if !(puppet is AntMound):
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	puppet.summon_chances = [0, 1, 0]
	get_puppet().brain_ant_killed.connect(on_ant_killed)

func exit():
	if get_puppet().brain_ant_killed.is_connected(on_ant_killed):
		get_puppet().brain_ant_killed.disconnect(on_ant_killed)

func enter() -> void:
	pass

func procces(_delta) -> void:
	wait -= _delta
	if wait <= 0:
		for child in get_puppet().ants.get_children():
			child.brain.force_transition("Flea")
		puppet.brain.force_transition("MoundScout")

func on_ant_killed(type: int):
	wait = 20
