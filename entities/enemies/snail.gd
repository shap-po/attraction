extends Puppet
class_name Snail

var allience: String = "bug"
var has_shell: bool = true
signal any_damage

@onready var slug_sprite: Sprite2D = $rotation_marker/slug_sprite
@onready var shell_sprite: Sprite2D = $rotation_marker/shell_sprite
@onready var health_shell: Health = $HealthShell

const SHELL_DOWN: Texture2D = preload("res://assets/textures/enemies/snail/shell-down.png")
const SHELL_LEFT: Texture2D = preload("res://assets/textures/enemies/snail/shell-left.png")
const SHELL_RIGHT: Texture2D = preload("res://assets/textures/enemies/snail/shell-right.png")
const SHELL_UP: Texture2D = preload("res://assets/textures/enemies/snail/shell-up.png")

const SLUG_DOWN: Texture2D = preload("res://assets/textures/enemies/snail/slug-down.png")
const SLUG_LEFT: Texture2D = preload("res://assets/textures/enemies/snail/slug-left.png")
const SLUG_RIGHT: Texture2D = preload("res://assets/textures/enemies/snail/slug-rigth.png")
const SLUG_UP: Texture2D = preload("res://assets/textures/enemies/snail/slug-up.png")

func fready() -> void:
	health_shell.on_zero.connect(on_zero_health_shell)

func _physics_process(_delta: float) -> void:
	choose_from_four_sprites(slug_sprite, SLUG_UP, SLUG_DOWN, SLUG_LEFT, SLUG_RIGHT)
	if shell_sprite.visible:
		choose_from_four_sprites(shell_sprite, SHELL_UP, SHELL_DOWN, SHELL_LEFT, SHELL_RIGHT)
	move_and_slide()

func take_damage(incoming_damage: int) -> void:
	any_damage.emit()
	if brain.current_state.name == "SnailHide":
		damage_shell(incoming_damage, 0.95)
	else:
		damage_shell(incoming_damage, 0.6)
		if not effects.is_stunned():
			brain.force_transition("SnailHide")
			return

func damage_shell(incoming_damage: int, penetration_chance: float) -> void:
	if not has_shell or randf() >= penetration_chance:
		health.damage(incoming_damage)
		return
	health_shell.damage(incoming_damage)

func on_zero_health_shell() -> void:
	has_shell = false
	shell_sprite.visible = false
