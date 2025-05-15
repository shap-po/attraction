extends State
class_name GnatIdle

# OVERVIEW
# will simply sit, jitter a bit and wait something to happen

@export var SPEED_MULTIPLIER: float = 0.1
var wait: float = -1.0

var speed: float
var target_point: Vector2

func on_creation() -> void:
	puppet.unconditional_state = "GnatAttackPlayer"

func procces(_delta: float) -> void:
	if puppet == null:
		return

	puppet.velocity = Vector2.ZERO
	var find: Puppet.FindType = puppet.check_area(Puppet.FindType.PLAYER)
	if find == Puppet.FindType.PLAYER:
		puppet.brain.force_transition("GnatAirborne")
		return

	if wait >= 0.0:
		puppet.velocity = Vector2.ZERO
