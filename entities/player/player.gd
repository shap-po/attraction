extends CharacterBody2D
class_name Player

const speed: int = 50
const weight: float = 0.4
var allience: String = "player"
var direction: Vector2 = Vector2.ZERO
var health: Health = Health.new(5)
@onready var inventory: PlayerInventory = $Inventory
@onready var current_weapon: ProjectileType = preload("res://assets/resources/projectiles/shoe.tres") as ProjectileType
@onready var current_plant: PlantType = preload("res://assets/resources/plant_types/chem_root.tres") as PlantType
@onready var PROJECTILE: PackedScene = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var player_sprite: Sprite2D = $player_sprite
@onready var dummy = %dummy
@onready var interaction_area: Area2D = $interaction_area
var can_shoot: bool = true


func _ready() -> void:
	shooting_cooldown.wait_time = current_weapon.cooldown

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		player_sprite.rotation = lerp_angle(player_sprite.rotation, velocity.angle(), weight)

	if Input.is_action_pressed("lcm") and can_shoot:
		can_shoot = false
		shooting_cooldown.start()
		var shoot_ang: float = get_local_mouse_position().normalized().angle()
		player_sprite.rotation = shoot_ang
		shoot(shoot_ang)
	if Input.is_action_just_pressed("interact"):
		interact()

	if Input.is_action_just_pressed("inventory"):
		print(inventory)
	if Input.is_action_just_pressed("rcm"): # for testing
		var item: WorldItem = current_plant.create_world_item()
		Global.main.items.add_child(item)
		item.global_position = global_position
	move_and_slide()

func shoot(shoot_ang: float) -> void:
	var projectile: PackedScene = preload("res://entities/projectile/projectile.tscn")
	var new_projectile: Projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = shoot_ang
	new_projectile.allience = "player"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)

func interact() -> Interactible.InteractionResult:
	var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
	# sort areas by distance to player
	# note: squared distance is faster to calculate and is sufficient for comparison
	areas.sort_custom(func(a: Area2D, b: Area2D): return global_position.distance_squared_to(a.global_position) <= global_position.distance_squared_to(b.global_position))

	# filter out interactibles
	var interactibles: Array[Interactible] = []
	for area in areas:
		if area is Interactible:
			interactibles.append(area)

	# try to interact with the closest interactible, if passed, try the next one
	for interactible in interactibles:
		var res: Interactible.InteractionResult = interactible.interact(self, current_plant)
		if res != Interactible.InteractionResult.PASS:
			return res

	return Interactible.InteractionResult.PASS

func _on_shooting_cooldown_timeout() -> void:
	can_shoot = true
