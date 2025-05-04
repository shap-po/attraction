extends CharacterBody2D
class_name Player

signal toggle_inventory

const speed: int = 160
const weight: float = 0.4
var allience: String = "player"
var direction: Vector2 = Vector2.ZERO
@onready var inventory: PlayerInventory = $Inventory
@onready var health: Health = $Health
@onready var current_weapon: ProjectileType = preload("res://assets/resources/projectiles/shoe.tres") as ProjectileType
@onready var current_plant: PlantType = preload("res://assets/resources/items/plant_types/chem_root.tres") as PlantType
@onready var PROJECTILE: PackedScene = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $ShootingCooldownTimer
@onready var interaction_cooldown: Timer = $InteractionCooldownTimer
@onready var body: Node2D = $Body
@onready var dummy = %dummy
@onready var interaction_area: Area2D = $InteractionArea2D
@onready var shop: Control = $"../CanvasLayer/shop"

var stun: float = 0.0

func _ready() -> void:
	shooting_cooldown.wait_time = current_weapon.cooldown

func _physics_process(_delta: float) -> void:

	if stun > 0:
		stun -= _delta
		return

	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		body.rotation = lerp_angle(body.rotation, velocity.angle(), weight)

	if Input.is_action_pressed("lcm") and shooting_cooldown.is_stopped():
		shooting_cooldown.start()
		var shoot_ang: float = get_local_mouse_position().normalized().angle()
		body.rotation = shoot_ang
		shoot(shoot_ang)
	if Input.is_action_pressed("interact") and interaction_cooldown.is_stopped():
		var res: Interactible.InteractionResult = interact()
		if res != Interactible.InteractionResult.PASS:
			interaction_cooldown.start()

	if Input.is_action_pressed("hotbar_next"):
		inventory.selected_slot += 1
	if Input.is_action_pressed("hotbar_previous"):
		inventory.selected_slot -= 1

	# toggle inventory
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

	if Input.is_action_just_pressed("space"):
		shop.toggle()


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

func take_damage(damage: int) -> void:
	health.damage(damage)

func apply_stun(time: float):
	Emote.create_emote(Emote.EmoteType.STUN, self)
	stun = time
