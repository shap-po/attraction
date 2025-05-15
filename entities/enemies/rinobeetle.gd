extends Puppet

var allience: String = "bug"
@onready var rinobeetle_sprite: Sprite2D = $rotation_marker/rinobeetle_sprite
const RINOBEETLE_UP: Texture2D = preload("res://assets/textures/enemies/rinobeetle/rinobeetle_up.png")
const RINOBEETLE_DOWN: Texture2D = preload("res://assets/textures/enemies/rinobeetle/rinobeetle_down.png")
const RINOBEETLE_LEFT: Texture2D = preload("res://assets/textures/enemies/rinobeetle/rinobeetle_left.png")
const RINOBEETLE_RIGHT: Texture2D = preload("res://assets/textures/enemies/rinobeetle/rinobeetle_right.png")

func _physics_process(_delta: float) -> void:
	choose_from_four_sprites(rinobeetle_sprite, RINOBEETLE_UP, RINOBEETLE_DOWN, RINOBEETLE_LEFT, RINOBEETLE_RIGHT)
	move_and_slide()
