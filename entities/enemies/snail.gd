extends Puppet
class_name Snail

var allience: String = "bug"
var has_shell = true
signal any_damage

@onready var slug_sprite: Sprite2D = $rotation_marker/slug_sprite
@onready var shell_sprite: Sprite2D = $rotation_marker/shell_sprite
@onready var health_shell: Health = $HealthShell

const SHELL_DOWN = preload("res://assets/textures/enemies/snail/shell-down.png")
const SHELL_LEFT = preload("res://assets/textures/enemies/snail/shell-left.png")
const SHELL_RIGHT = preload("res://assets/textures/enemies/snail/shell-right.png")
const SHELL_UP = preload("res://assets/textures/enemies/snail/shell-up.png")

const SLUG_DOWN = preload("res://assets/textures/enemies/snail/slug-down.png")
const SLUG_LEFT = preload("res://assets/textures/enemies/snail/slug-left.png")
const SLUG_RIGHT = preload("res://assets/textures/enemies/snail/slug-rigth.png")
const SLUG_UP = preload("res://assets/textures/enemies/snail/slug-up.png")

func fready():
	health_shell.on_zero.connect(on_zero_health_shell)

func _physics_process(_delta: float) -> void:
	choose_from_four_sprites(slug_sprite, SLUG_UP, SLUG_DOWN, SLUG_LEFT, SLUG_RIGHT)
	if shell_sprite.visible:
		choose_from_four_sprites(shell_sprite, SHELL_UP, SHELL_DOWN, SHELL_LEFT, SHELL_RIGHT)
	move_and_slide()
	
	
func take_damage(damage):
	any_damage.emit()
	if brain.current_state.name == "SnailHide":
		damage_shell(damage, 0.95)
	else:
		if !(effects[0] > 0):
			brain.force_transition("SnailHide")
		damage_shell(damage, 0.6)
	#print("[snail] health: ", health.value, " health_shell: ", health_shell.value)

func damage_shell(damage, penetration_chance: float):
	if (!has_shell) || (randf() < (1 - penetration_chance)):
		health.damage(damage)
		return
	health_shell.damage(damage)

func on_zero_health_shell():
	has_shell = false
	shell_sprite.visible = false
