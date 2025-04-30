extends Area2D
class_name Projectile

@onready var projectile_sprite: Sprite2D = $projectile_sprite
@onready var projectile_collision: CollisionShape2D = $projectile_collision
@onready var lifetime: Timer = $lifetime
var allience: String
var res
var speed: float
var deseleration: float
var direction
var rotation_speed
var keep_rotating: bool
var destroy_on_collision: bool
var damage: int
var rotation_inaccuracy: float
var speed_inaccuracy: float

func _ready():
	projectile_sprite.texture = res.texture
	projectile_collision.shape = res.collision_shape
	speed_inaccuracy = res.speed_inaccuracy
	speed = res.speed + randf_range(-speed_inaccuracy, speed_inaccuracy)
	deseleration = res.deseleration
	rotation_inaccuracy = res.rotation_inaccuracy
	direction = Vector2.RIGHT.rotated(rotation + deg_to_rad(randf_range(-rotation_inaccuracy, rotation_inaccuracy)))
	if res.random_rotation: self.rotation = randf() * 2
	rotation_speed = deg_to_rad(res.rotation_deg)
	keep_rotating = res.keep_rotating
	lifetime.wait_time = res.lifetime
	lifetime.start()
	destroy_on_collision = res.destroy_on_collision
	damage = res.damage
	self.scale = Vector2(1, 1) * res.scaling
	


func _physics_process(_delta: float) -> void:
	global_position += speed * direction
	if speed > deseleration:
		speed -= deseleration
	else:
		speed = 0
	if (rotation_speed != 0) && ((speed != 0)||(keep_rotating)):
		self.rotation += rotation_speed


func destroy():
	queue_free()

func _on_lifetime_timeout() -> void:
	destroy()


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_method("take_damage"):
		if body.allience != allience:
			body.take_damage(damage)
			if destroy_on_collision:
				destroy()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		if area.allience != allience:
			area.take_damage(damage)
			if destroy_on_collision:
				destroy()
