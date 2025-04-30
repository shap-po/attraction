extends State
class_name SnailScoutFood


func on_creation():
	#puppet.unconditional_state = "SnailScoutFood"
	puppet.apply_stun(5)

func procces(_delta) -> void:
	pass
