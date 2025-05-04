extends CharacterBody2D
class_name Puppet

var unconditional_state: String = "NoAi"
@export var speed: float
@export var weight: float = 0.4
var target: Node2D
@onready var current_weapon: ProjectileType = preload("res://assets/resources/projectiles/bite.tres") as ProjectileType

@onready var dummy: Node2D = get_parent()

enum FindType {
	PLAYER,
	PLANT,
	NONE
}
@onready var collision_area_shape: CollisionShape2D = $collision_area_shape
@onready var rotation_marker: Marker2D = $rotation_marker
@onready var area_sight: Area2D = $rotation_marker/area_sight
@onready var area_touch: Area2D = $rotation_marker/area_touch
@onready var health: Health = $Health
@onready var brain: StateMachine = $brain
@onready var timer: Timer = $timer
@onready var acting_cooldown: Timer = $ShootingCooldownTimer
var melee_cooldown: float = 0.75
var can_act: bool = true

var effects: Array[float] = [-1]

##                           stun,
func _ready() -> void:
	acting_cooldown.timeout.connect(on_acting_cooldown_up)
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
	if not can_act:
		return
	can_act = false
	var projectile: PackedScene = preload("res://entities/projectile/projectile.tscn")
	var new_projectile: Projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = shoot_ang
	new_projectile.allience = "bug"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)
	acting_cooldown.wait_time = current_weapon.cooldown
	acting_cooldown.start()

func melee(damage: int, cooldown: float = 0.75) -> void:
	if target == null:
		return
	if not can_act:
		return
	can_act = false

	if target.has_method("take_damage"):
		target.take_damage(damage)

	var pv = Vector2(0, -1).rotated(randf_range(-0.4, 0.4))
	var pos1 = target.global_position - pv * 5
	var pos2 = target.global_position + pv * 5
	var rot2 = pv.angle()
	var rot1 = pv.angle()

	Emote.create_emote(Emote.EmoteType.BITE_LOWER, target, pv, 0.4, pos1, rot1, false, 0.5, 15)
	Emote.create_emote(Emote.EmoteType.BITE_UPPER, target, pv * -1, 0.4, pos2, rot2, false, 0.5, 15)
	acting_cooldown.wait_time = cooldown
	acting_cooldown.start()

func on_acting_cooldown_up():
	can_act = true

func check_area(priority: FindType = FindType.PLAYER) -> FindType:
	var areas: Array[Area2D] = area_sight.get_overlapping_areas()
	var ret: FindType = FindType.NONE
	if areas:
		for area in areas:
			if area is Plant:
				target = area
				ret = FindType.PLANT
				if priority == FindType.PLANT: return ret
			if area.name == "InteractionArea2D": ## if yk better solution let me know -peu
				target = area.get_parent()
				ret = FindType.PLAYER
				if priority == FindType.PLAYER: return ret
	return ret
