extends State
class_name worker_scout

# OVERVIEW
# worker will try to wander towards food, if it finds it
# ant will return to base
# if approached will flea
# if whitnesses damage/kill will hide



func on_creation():
	if !(puppet is ant_worker): 
		push_error("something initiated braincell of ant_worker without it actually being ant_worker.")
		return
	
