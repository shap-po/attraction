extends Puppet
class_name Ant

enum AntType {
	WORKER = 0,
	WARRIOR = 1
}

signal ant_damaged(type: AntType)
signal ant_killed(type: AntType)
@warning_ignore("unused_signal")
signal enter_home(type: AntType)

@export var type: AntType

var jitter: float = 0.05 + randf_range(-0.01, 0.05)

var allience: String = "bug"
var home: Node2D = null

func _physics_process(_delta: float) -> void:
	rotate_where_going(jitter)
	move_and_slide()
	additional_to_process(_delta)

func additional_to_process(_delta: float):
	pass

func take_damage(damage: int) -> void:
	alert_other_ants(self.global_position)
	ant_damaged.emit(type)
	health.damage(damage)

func on_zero_health() -> void:
	ant_killed.emit(type)
	queue_free()

func alert_other_ants(pos: Vector2) -> void: ## the ant will alert itself
	var bodies: Array[Node2D] = area_sight.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.has_method("on_alerted"):
				body.on_alerted(pos)

func on_alerted(pos: Vector2) -> void:
	if self.brain.current_state.has_method("on_alerted"):
		self.brain.current_state.on_alerted(pos)
