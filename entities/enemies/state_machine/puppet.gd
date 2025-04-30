extends CharacterBody2D
class_name Puppet

var unconditional_state: String = "NoAi"
@export var speed: float
@export var weight: float = 0.4

var target: Node2D

@onready var current_weapon: ProjectileType = preload("res://assets/resources/projectiles/bite.tres") as ProjectileType

@onready var dummy = %dummy
@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch
@onready var health: Health = $Health
@onready var brain: StateMachine = $brain
@onready var timer: Timer = $timer
@onready var shooting_cooldown: Timer = $ShootingCooldownTimer
var can_shoot = true

var effects: Array[float] = [-1]
##                           stun,
func _ready() -> void:
	shooting_cooldown.timeout.connect(on_shooting_cooldown_up)
	health.on_zero.connect(on_zero_health)
	fready()

func fready():
	pass

func rotate_where_going(jitter: float):
	if effects[0] > -1:
		return
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1, 2)) * jitter * randf()

func choose_from_four_sprites(sprite_node: Sprite2D, texture_up, texture_down, texture_left, texture_right):
	if effects[0] > -1:
		return
	var rot = rad_to_deg(velocity.angle())
	if rot < 0: rot += 360
	if (rot > 315) || (rot <= 45):
		sprite_node.texture = texture_right
	if (rot > 45) && (rot <= 135):
		sprite_node.texture = texture_down
	if (rot > 135) && (rot <= 225):
		sprite_node.texture = texture_left
	if (rot > 225) && (rot <= 315):
		sprite_node.texture = texture_up

func apply_stun(ticks):
	Emote.create_emote(Emote.EmoteType.STUN, self)
	effects[0] = ticks


func take_damage(damage: int) -> void:
	health.damage(damage)
	on_damage_effect()

func on_zero_health() -> void:
	on_death_effect()
	queue_free()

func on_death_effect() -> void:
	pass
func on_damage_effect() -> void:
	pass


func shoot(shoot_ang: float) -> void:
	if !can_shoot:
		return
	can_shoot = false
	var projectile: PackedScene = preload("res://entities/projectile/projectile.tscn")
	var new_projectile: Projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = shoot_ang
	new_projectile.allience = "bug"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)
	
	shooting_cooldown.wait_time = current_weapon.cooldown
	shooting_cooldown.start()

func on_shooting_cooldown_up():
	can_shoot = true

	
