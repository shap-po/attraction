extends State
class_name MoundRaid

var time_next_state: float = 15

func get_puppet() -> AntMound:
	return puppet as AntMound

func on_creation() -> void:
	if not puppet is AntMound:
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	time_next_state = 15
	get_puppet().summon_chances = [0.4, 1, 0]
	get_puppet().brain_ant_killed.connect(on_ant_killed)

func exit():
	for child in get_puppet().ants.get_children():
		if child.has_method("take_damage"):
			if child.type == Ant.AntType.WORKER:
				child.brain.force_transition("WorkerScout")
				child.brain.current_state.target_point = puppet.target.global_position
			if child.type == Ant.AntType.WARRIOR:
				child.brain.force_transition("WarriorEscort")
	if get_puppet().brain_ant_killed.is_connected(on_ant_killed):
		get_puppet().brain_ant_killed.disconnect(on_ant_killed)

func enter() -> void:
	pass

func procces(_delta: float) -> void:
	time_next_state -= _delta
	if time_next_state <= 0:
		get_puppet().brain.force_transition("MoundScout")

func on_ant_killed(type: Ant.AntType) -> void:
	if randf() < 0.5:
		return

	for child in get_puppet().ants.get_children():
		if child.has_method("take_damage"):
			if child.type == 0:
				child.brain.force_transition("Flea")
	get_puppet().brain.force_transition("MoundDefend")
