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

func take_damage(damage: int) -> void:
	ant_damaged.emit(type)
	health.damage(damage)

func on_zero_health() -> void:
	ant_killed.emit(type)
	queue_free()
