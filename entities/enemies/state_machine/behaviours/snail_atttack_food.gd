extends State
class_name SnailAttackFood

# OVERVIEW
# will simply approach food and attack it
# if disturbed will transfer to "snail_hide"

func on_creation():
	puppet.unconditional_state = "SnailAttackFood"
