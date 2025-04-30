extends State
class_name GnatAirborne

# OVERVIEW
# this is a transit behaviour; does nothing meaningfull on its own

var scale_mod: float = 1
var n_state: String

func on_creation():
	n_state = puppet.unconditional_state 
	if n_state == "GnatIdle":
		scale_mod = 1
		#print("[GnatAirborne] GnatAttackPlayer => GnatAirborne")
	if n_state == "GnatAttackPlayer":
		scale_mod = 0.7
		#print("[GnatAirborne] GnatIdle => GnatAirborne")

func procces(_delta) -> void:
	#print("[GnatAirborne] scale_mod =", scale_mod)
	#print("[GnatAirborne] n_state =", n_state)
	if n_state == "GnatIdle":
		scale_mod -= 0.01
	if n_state == "GnatAttackPlayer":
		scale_mod += 0.005
	
	
	puppet.scale = Vector2(1, 1) * scale_mod
	if (scale_mod >= 1) && (n_state == "GnatAttackPlayer"):
		scale_mod = 1.01
		next_state()
	if (scale_mod <= 0.7) && (n_state == "GnatIdle"):
		scale_mod = 0.69
		next_state()
	
func next_state():
	#print("[GnatAirborne] GnatAirborne => ", n_state)
	puppet.brain.force_transition(n_state)
