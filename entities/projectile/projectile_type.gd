extends Item
class_name ProjectileType

const PROJECTILE: PackedScene = preload("res://entities/projectile/projectile.tscn")

@export var texture: Texture2D
@export var collision_shape: RectangleShape2D
@export_range(1, 100) var damage: int = 1
@export var speed: float = 0.0
@export var deseleration: float = 0.0
@export var lifetime: float = 1.0
@export var scaling: float = 1.0
@export var destroy_on_collision: bool = true
@export var is_boomerang: bool = false
@export var cooldown: float = 1.0
@export_range(0, 360) var rotation_deg: int = 0
@export_range(0, 360) var rotation_inaccuracy: float = 1.0 ## in deg
@export var speed_inaccuracy: float = 1.0 ## in whatever speed is
@export var keep_rotating: bool = false ## Should it keep rotating after stop?
@export var random_rotation: bool = false
@export var hazardeous: bool = false ## Does it ignore allience?

func create(angle: float, alliance: String) -> Projectile:
	var instance: Projectile = PROJECTILE.instantiate()
	instance.global_rotation = angle
	instance.allience = alliance
	instance.projectile_type = self
	return instance
