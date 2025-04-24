extends CharacterBody2D
class_name AntWarrior

const jitter = 0.05

var type = 1
var allience = "bug"
const weight: float = 0.4
var health: Health = Health.new(5)
@export var speed = 15
@onready var brain: StateMachine = $brain

signal ant_damaged
signal ant_killed
signal enter_home(type)

@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch
@onready var timer: Timer = $timer
var home: Node2D = null

func _ready() -> void:
	health.on_zero.connect(on_zero_health)


func  _physics_process(delta: float) -> void:
	
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1,2)) * jitter * randf()
	
	move_and_slide()

func take_damage(dmg):
	ant_damaged.emit(type)
	health.damage(dmg)
	
func on_zero_health():
	ant_killed.emit(type)
	queue_free()
