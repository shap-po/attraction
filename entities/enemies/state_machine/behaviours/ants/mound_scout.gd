extends State
class_name mound_scout

# OVERVIEW
# this behaviour will make mound preoritize workers over warriors
# and create warriors with "warrior_defend_base";
# create workers with "worker_scout" untill food is found or 
# the hive is provoked



func on_creation():
	if !(puppet is ant_mound): 
		push_error("something initiated braincell of ant_mound without it actually being ant_mound.")
		return
	

func enter():
	pass
	
func procces():
	pass
