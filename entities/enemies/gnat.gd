extends Puppet
class_name Gnat

var allience: String = "bug"


func _physics_process(_delta: float) -> void:
	#print(brain.current_state)
	rotate_where_going(0.0)
	move_and_slide()
