extends CharacterBody2D
class_name Puppet

var unconditional_state: String = "NoAi"
@export var speed: float
@export var weight: float = 0.4

var target: Node2D

@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch
@onready var health: Health = $Health
@onready var brain: StateMachine = $brain
@onready var timer: Timer = $timer

func _ready() -> void:
	health.on_zero.connect(on_zero_health)

func rotate_where_going(jitter: float):
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1, 2)) * jitter * randf()

func choose_from_four_sprites(sprite_node: Sprite2D, texture_up, texture_down, texture_left, texture_right):
	var rot = rad_to_deg(velocity.angle())
	if rot < 0: rot += 360
	print(rot)
	if (rot > 315) || (rot <= 45):
		sprite_node.texture = texture_right
	if (rot > 45) && (rot <= 135):
		sprite_node.texture = texture_down
	if (rot > 135) && (rot <= 225):
		sprite_node.texture = texture_left
	if (rot > 225) && (rot <= 315):
		sprite_node.texture = texture_up


func take_damage(damage: int) -> void:
	health.damage(damage)

func on_zero_health() -> void:
	queue_free()
