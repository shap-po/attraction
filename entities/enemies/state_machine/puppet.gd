extends CharacterBody2D
class_name Puppet

@onready var brain: StateMachine = $brain
@onready var timer: Timer = $timer
var unconditional_state: String = "NoAi"
var health: Health
var speed: float
var weight: float = 0.4
var target: Node2D 

@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch

func rotate_where_going(jitter: float):
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1, 2)) * jitter * randf()	

func take_damage(damage: int) -> void:
	health.damage(damage)

func on_zero_health() -> void:
	queue_free()
