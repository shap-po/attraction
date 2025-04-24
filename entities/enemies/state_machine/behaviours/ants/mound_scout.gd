extends State
class_name MoundScout

# OVERVIEW
# this behaviour will make mound preoritize workers over warriors
# and create warriors with "warrior_defend_base";
# create workers with "worker_scout" untill food is found or 
# the hive is provoked



func on_creation():
	if !(puppet is AntMound): 
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	puppet.brain_ant_killed.connect(on_ant_killed)
	

func enter():
	pass
	
func procces():
	puppet.summon_ant(0)
	pass


func on_ant_killed(type: int):
	for child in puppet.ants.get_children():
		if child.type == 0:
			child.brain.force_transition("Flea")
		if child.type == 1:
			child.brain.force_transition("Flea")
	puppet.brain.force_transition("NoAi")
