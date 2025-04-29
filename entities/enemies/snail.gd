extends Puppet
class_name Snail

var allience: String = "bug"

@onready var slug_sprite: Sprite2D = $rotation_marker/slug_sprite
@onready var shell_sprite: Sprite2D = $rotation_marker/shell_sprite

const SHELL_DOWN = preload("res://assets/textures/enemies/snail/shell-down.png")
const SHELL_LEFT = preload("res://assets/textures/enemies/snail/shell-left.png")
const SHELL_RIGHT = preload("res://assets/textures/enemies/snail/shell-right.png")
const SHELL_UP = preload("res://assets/textures/enemies/snail/shell-up.png")

const SLUG_DOWN = preload("res://assets/textures/enemies/snail/slug-down.png")
const SLUG_LEFT = preload("res://assets/textures/enemies/snail/slug-left.png")
const SLUG_RIGHT = preload("res://assets/textures/enemies/snail/slug-rigth.png")
const SLUG_UP = preload("res://assets/textures/enemies/snail/slug-up.png")

func _physics_process(_delta: float) -> void:
	
	choose_from_four_sprites(slug_sprite, SLUG_UP, SLUG_DOWN, SLUG_LEFT, SLUG_RIGHT)
	choose_from_four_sprites(shell_sprite, SHELL_UP, SHELL_DOWN, SHELL_LEFT, SHELL_RIGHT)
	move_and_slide()
