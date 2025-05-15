extends State
class_name SnailHide

# OVERVIEW
# will simply sit and waits for attacks to stop

@export var HIDE_TIME: float = 5
var wait: float

func get_puppet() -> Snail:
	return puppet as Snail

func on_creation() -> void:
	if not get_puppet().has_shell:
		puppet.brain.force_transition(puppet.unconditional_state)
		return
	create_emote(Emote.EmoteType.WARNING)
	wait = HIDE_TIME
	puppet.velocity = Vector2.ZERO
	get_puppet().slug_sprite.visible = false
	get_puppet().any_damage.connect(on_any_damage)
	get_puppet().health_shell.on_zero.connect(on_shell_broken)

func procces(delta: float) -> void:
	#print(wait)
	if wait < 0:
		puppet.brain.force_transition(puppet.unconditional_state)
	else:
		wait -= 1 * delta

func exit() -> void:
	get_puppet().slug_sprite.visible = true
	if get_puppet().any_damage.is_connected(on_any_damage):
		get_puppet().any_damage.disconnect(on_any_damage)
	if get_puppet().health_shell.on_zero.is_connected(on_shell_broken):
		get_puppet().health_shell.on_zero.disconnect(on_shell_broken)


func on_any_damage() -> void:
	wait = HIDE_TIME

func on_shell_broken():
	puppet.brain.force_transition(puppet.unconditional_state)
