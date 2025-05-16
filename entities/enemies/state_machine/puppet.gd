extends CharacterBody2D
class_name Puppet

var unconditional_state: String = "NoAi"
@export var speed: float
@export var weight: float = 0.4
@export_range(0, 100) var damage: int = 0
var target: Node2D

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

##                           stun timer,
func _ready() -> void:
	acting_cooldown.timeout.connect(on_acting_cooldown_up)
	health.on_zero.connect(on_zero_health)
	fready()

func fready() -> void:
	pass

func rotate_where_going(jitter: float) -> void:
	if effects[0] > -1:
		return
	if velocity != Vector2.ZERO:
		rotation_marker.rotation = lerp_angle(rotation_marker.rotation, velocity.angle(), weight) + pow(-1, randi_range(1, 2)) * jitter * randf()

func choose_from_four_sprites(sprite_node: Sprite2D, texture_up: Texture2D, texture_down: Texture2D, texture_left: Texture2D, texture_right: Texture2D) -> void:
	if effects[0] > -1:
		return
	var rot: float = rad_to_deg(velocity.angle())
	if rot < 0:
		rot += 360
	if rot > 315 or rot <= 45:
		sprite_node.texture = texture_right
	if rot > 45 and rot <= 135:
		sprite_node.texture = texture_down
	if rot > 135 and rot <= 225:
		sprite_node.texture = texture_left
	if rot > 225 and rot <= 315:
		sprite_node.texture = texture_up

func apply_stun(ticks: float) -> void:
	Emote.create_emote(Emote.EmoteType.STUN, self)
	effects[0] = ticks

func take_damage(damage: int) -> void:
	health.damage(damage)
	on_damage_effect()

func on_zero_health() -> void:
	on_death_effect()
	Util.remove_node(self)

func on_death_effect() -> void:
	pass

func on_damage_effect() -> void:
	pass

func melee(damage: int = self.damage, cooldown: float = 0.75) -> void:
	if target == null:
		return
	if not can_act:
		return

	can_act = false

	if target.has_method("take_damage"):
		target.take_damage(damage)

	var pv: Vector2 = Vector2(0, -1).rotated(randf_range(-0.4, 0.4))
	var pos1: Vector2 = target.global_position - pv * 5
	var pos2: Vector2 = target.global_position + pv * 5
	var rot2: float = pv.angle()
	var rot1: float = pv.angle()

	Emote.create_emote(Emote.EmoteType.BITE_LOWER, target, pv, 0.4, pos1, rot1, false, 0.5, 15)
	Emote.create_emote(Emote.EmoteType.BITE_UPPER, target, pv * -1, 0.4, pos2, rot2, false, 0.5, 15)

	acting_cooldown.wait_time = cooldown
	acting_cooldown.start()

func on_acting_cooldown_up():
	can_act = true

func check_area(priority: FindType = FindType.PLAYER) -> FindType:
	var areas: Array[Area2D] = area_sight.get_overlapping_areas()
	var res: FindType = FindType.NONE
	for area in areas:
		if area is Plant:
			target = area
			res = FindType.PLANT
			if priority == FindType.PLANT:
				return res
		if area.name == "InteractionArea2D": ## if yk better solution let me know -peu
			target = area.get_parent()
			res = FindType.PLAYER
			if priority == FindType.PLAYER:
				return res
	return res
