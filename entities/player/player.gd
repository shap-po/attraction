extends CharacterBody2D

const speed: int = 50
const weight: float = 0.4
var allience: String = "player"
var direction: Vector2 = Vector2.ZERO
var health: Health = Health.new(5)

@onready var current_weapon: ProjectileType = preload("res://assets/resources/projectiles/shoe.tres") as ProjectileType
@onready var current_plant: PlantType = preload("res://assets/resources/plant_types/chem_root.tres") as PlantType
@onready var PROJECTILE: PackedScene = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var player_sprite: Sprite2D = $player_sprite
@onready var dummy = %dummy
@onready var interaction_area: Area2D = $interaction_area

var shoot_r: bool = true


func _ready():
	shooting_cooldown.wait_time = current_weapon.cooldown

func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		player_sprite.rotation = lerp_angle(player_sprite.rotation, velocity.angle(), weight)

	if (Input.is_action_pressed("lcm")) and (shoot_r == true):
		shoot_r = false
		shooting_cooldown.start()
		var shoot_ang = get_local_mouse_position().normalized().angle()
		player_sprite.rotation = shoot_ang
		shoot(shoot_ang)
	if Input.is_action_just_pressed("rcm"):
		interact()
	move_and_slide()

func shoot(shoot_ang):
	var projectile = preload("res://entities/projectile/projectile.tscn")
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = shoot_ang
	new_projectile.allience = "player"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)

func interact():
	var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
	areas.sort_custom(func(a: Area2D, b: Area2D): return global_position.distance_squared_to(a.global_position) <= global_position.distance_squared_to(b.global_position))
	var area: Area2D = areas.pop_front()
	if area == null:
		return
	if area is Interactible:
		var res: Interactible.InteractionResult = area.interact(current_plant)

func _on_shooting_cooldown_timeout() -> void:
	shoot_r = true
