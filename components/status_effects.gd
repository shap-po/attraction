extends Node
class_name StatusEffects

signal on_stun_finish()

var stun_timer: float = 0.0

func apply_stun(ticks: float) -> void:
	stun_timer = max(stun_timer, ticks)
	set_physics_process(true)

func is_stunned() -> bool:
	return stun_timer > 0

func _ready() -> void:
	# Disable physics processing by default
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if stun_timer > 0:
		stun_timer -= delta
	else:
		stun_timer = 0
		on_stun_finish.emit()
		set_physics_process(false)
