extends Node
class_name StateMachine

@export var initial_state: State
@export var puppet: Node2D
var block_transitions = false
var current_state: State
var states_dict: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.puppet = puppet
			states_dict[child.name.to_upper()] = child
			#child.transitioned_signal.connect(on_child_transition)
	if initial_state != null:
		initial_state.fenter()
		current_state = initial_state

func _physics_process(_delta: float) -> void:
	if current_state != null:
		current_state.fprocces(_delta)

func on_child_transition(old_state: State, new_state_name: String) -> void:
	if old_state != current_state:
		return

	var new_state: State = states_dict.get(new_state_name.to_upper())
	if new_state == null:
		return

	if current_state:
		current_state.exit()

	new_state.enter()

func force_transition(new_state_name: String)-> void:
	if block_transitions:
		return
	#print("[StateMacine] ", current_state.name, " => ", new_state_name)
	var new_state: State = states_dict.get(new_state_name.to_upper())
	if new_state == null:
		return
	if current_state == new_state:
		return
	if current_state != null:
		current_state.fexit()
	current_state = new_state
	current_state.fenter()
