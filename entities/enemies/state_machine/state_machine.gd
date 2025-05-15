extends Node
class_name StateMachine

@export var initial_state: State
@export var puppet: Node2D
var block_transitions: bool = false
@export var hunger: int = 1
var current_state: State
var states_dict: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.puppet = puppet
			states_dict[child.name.to_upper()] = child
	if initial_state != null:
		initial_state.fenter()
		current_state = initial_state

func _physics_process(_delta: float) -> void:
	if current_state != null:
		current_state.fprocces(_delta)

## Transitiones from one state to another
## Pro tip: Most of the time you want to use `return` after running this function
func force_transition(new_state_name: String)-> void:
	if block_transitions:
		return
	#print("[StateMacine] ", current_state.name, " => ", new_state_name)
	var new_state: State = states_dict.get(new_state_name.to_upper())
	if new_state == null:
		print("[StateMachine] WARNING: could not find state by the name \"", new_state_name, "\" in ", self.get_parent().name)
		return
	if current_state == new_state:
		return
	if current_state != null:
		current_state.fexit()
	current_state = new_state
	current_state.fenter()
