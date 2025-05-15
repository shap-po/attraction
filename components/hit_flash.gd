## Controls the hit flash effect on the sprite when the player takes damage.
## This script must be attached to a Health node.
@tool
extends Node

const HIT_FLASH: VisualShader = preload("res://assets/shaders/hit_flash.tres")
@onready var health: Health = get_parent()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var sprite: Sprite2D:
	set(val):
		sprite = val
		if Engine.is_editor_hint():
			setup()

func _ready() -> void:
	if not Engine.is_editor_hint():
		health.on_damage.connect(on_damage)

func setup() -> void:
	if sprite == null:
		return
	if sprite.material != null:
		push_warning("Sprite already have a material!")
		return

	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = HIT_FLASH
	# make sure material changes are local to the node
	material.resource_local_to_scene = true
	sprite.material = material

	print("Setup sprite's material")

func on_damage(_dmg: int) -> void:
	animation_player.play("hit_flash")
