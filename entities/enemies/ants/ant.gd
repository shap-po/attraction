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

var type: AntType

var jitter: float = 0.05 + randf_range(-0.01, 0.05)

var allience: String = "bug"
var weight: float
var home: Node2D = null
@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch

func _physics_process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1, 2)) * jitter * randf()

	move_and_slide()

func take_damage(damage: int) -> void:
	ant_damaged.emit(type)
	health.damage(damage)

func on_zero_health() -> void:
	ant_killed.emit(type)
	queue_free()
