extends State
class_name SnailHide

# OVERVIEW
# will simply sit and waits for attacks to stop

var wait = 100

func on_creation():
	if !puppet.has_shell:
		puppet.brain.force_transition(puppet.unconditional_state)
	puppet.slug_sprite.visible = false
	puppet.any_damage.connect(on_any_damage)
	puppet.health_shell.on_zero.connect(on_shell_broken)

func process(delta: float) -> void:
	
	if wait < 0:
		puppet.brain.force_transition(puppet.unconditional_state)
	else:
		wait -= 1 * delta
	
func exit():
	puppet.slug_sprite.visible = true
	if puppet.any_damage.is_connected():
		puppet.any_damage.disconnect(on_any_damage)
	if puppet.health_shell.on_zero.is_connected():
		puppet.health_shell.on_zero.disconnect(on_shell_broken)
	
	
func on_any_damage():
	wait = 100
	
func on_shell_broken():
	puppet.brain.force_transition(puppet.unconditional_state)
