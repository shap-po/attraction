extends State
class_name WarriorEscort


@export var SPEED_MULTIPLIER: float = 1.2 * randf_range(0.95, 1.1)
var speed
var target_point 
var protection_target = null

func on_creation():
	Emote.create_emote(Emote.EmoteType.WARNING, puppet)
	if protection_target is AntWorker:
		protection_target = target_point 
	speed = puppet.speed * SPEED_MULTIPLIER
	puppet.unconditional_state = "WarriorEscort"
	if !puppet.target:
		puppet.brain.force_transition("WarriorLinger")
	
func choose_new_point() -> void:
	if puppet == null:
		return
	target_point = protection_target.global_position + Vector2.ZERO.rotated(protection_target.rotation_marker.rotation) * 10

func process(_delta):
	var find: Puppet.FindType = puppet.check_area()
	if find == Puppet.FindType.PLAYER:
		if (puppet.global_position.distance_squared_to(puppet.target.global_position) < 1400):
			puppet.brain.force_transition("WarriorRage")
			return



func on_alerted(pos):
	var find = puppet.check_area()
	puppet.unconditional_state = "WarriorRage"
	if (find == puppet.FindType.PLAYER):
		puppet.brain.force_transition("WarriorRage")
