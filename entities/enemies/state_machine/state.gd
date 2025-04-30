extends Node
class_name State

@warning_ignore("unused_signal")
signal transitioned_signal(previous_state: State, new_state_name: String) ## Emitted when the state is transitioned to another state

var puppet: Puppet
var first_iteration: bool = true

func create_emote(type: Emote.EmoteType):
	Emote.create_emote(type, puppet)

func fenter() -> void:
	enter()

func enter() -> void:
	pass

func fexit() -> void:
	first_iteration = true
	exit()

func exit() -> void:
	pass

func fprocces(_delta) -> void:
	if first_iteration: # this shit so ass, im sorry
		first_iteration = false
		on_creation()
		return
	if puppet.effects[0] > -1:
		puppet.effects[0] -= 1 * _delta
		puppet.rotation = 15 * cos(puppet.effects[0])
		if puppet.effects[0] < 0:
			puppet.rotation = 0
			puppet.effects[0] = -1
			Emote.create_emote(Emote.EmoteType.WARNING, puppet)
		return
	procces(_delta)

func procces(_delta) -> void:
	pass

func on_creation() -> void:
	pass

## Can be reimplemented by classes that extend State to return puppet as a correct type
func get_puppet() -> Puppet:
	return puppet
