extends State
class_name warrior_defend_base

# OVERVIEW
# warrior will try to patrol around the mound, if he has one 
# if approached will warn and the attack
# if provoked will attack
# if whitnesses damage/kill will attack




func on_creation():
	if !(puppet is ant_warrior): 
		push_error("something initiated braincell of ant_warrior without it actually being ant_warrior.")
		return
	
