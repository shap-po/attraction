extends Puppet
class_name Gnat

var allience: String = "bug"


func _ready() -> void:
	health = Health.new(1)
	speed = 100
	health.on_zero.connect(on_zero_health)

func _physics_process(_delta: float) -> void:
	#print(brain.current_state)
	rotate_where_going(0.0)
	move_and_slide()
