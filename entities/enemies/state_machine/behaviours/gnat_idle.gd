extends State
class_name GnatIdle

# OVERVIEW
# will simply sit, jitter a bit and wait something to happen
# will

@export var SPEED_MULTIPLIER: float = 0.1
var wait: float = -1.0

var speed: float
var target_point: Vector2

func on_creation() -> void:
	puppet.unconditional_state = "GnatAttackPlayer"



func procces(_delta) -> void:
	if puppet == null:
		return
	puppet.velocity = Vector2.ZERO
	var areas: Array[Area2D] = puppet.area_sight.get_overlapping_areas()
	if areas:
		for area in areas:
			if area.name == "InteractionArea2D": ## if yk better solution let me know -peu
				puppet.target = area.get_parent()
				puppet.brain.force_transition("GnatAirborne")
				return
	if wait >= 0.0:
		puppet.velocity = Vector2.ZERO
		return
