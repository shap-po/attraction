extends Resource
class_name ProjectileType

@export var name: String
@export var texture: Texture2D
@export var collision_shape: RectangleShape2D
@export var damage: int = 1
@export var speed: float = 0.0
@export var deseleration: float = 0.0
@export var lifetime: float = 1.0
@export var destroy_on_collision: bool = true
@export var is_boomerang: bool = false
@export var cooldown: float = 1.0
@export var rotation_deg: int = 0
@export var keep_rotating: bool = false # keep rotating after stop?
@export var random_rotation: bool = false
@export var hazardeous: bool = false #does it ignore allience?
