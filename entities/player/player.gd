extends CharacterBody2D
class_name Player

const speed: int = 100
const weight: float = 0.4
var allience: String = "player"
var direction: Vector2 = Vector2.ZERO
@onready var inventory: PlayerInventory = $Inventory
@onready var health: Health = $Health
@onready var PROJECTILE: PackedScene = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $ShootingCooldownTimer
@onready var interaction_cooldown: Timer = $InteractionCooldownTimer
@onready var body: Node2D = $Body
@onready var interaction_area: Area2D = $InteractionArea2D

@onready var inventory_ui: Control = $"../UICanvasLayer/inventory_UI"
@onready var shop: Control = $"../UICanvasLayer/shop"
var stun: float = 0.0

func _physics_process(_delta: float) -> void:
	if stun > 0:
		stun -= _delta
		return

	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		body.rotation = lerp_angle(body.rotation, velocity.angle(), weight)

	if not is_gui_open():
		if Input.is_action_pressed("lcm") and shooting_cooldown.is_stopped() and inventory.get_selected_item() is ProjectileType:
			shooting_cooldown.start()
			var shoot_ang: float = get_local_mouse_position().normalized().angle()
			body.rotation = shoot_ang
			shoot(shoot_ang, inventory.get_selected_item() as ProjectileType)
		if Input.is_action_pressed("interact") and interaction_cooldown.is_stopped():
			var res: Interactible.InteractionResult = interact()
			if res != Interactible.InteractionResult.PASS:
				interaction_cooldown.start()

	if Input.is_action_just_released("hotbar_next"):
		inventory.selected_slot += 1
	if Input.is_action_just_released("hotbar_previous"):
		inventory.selected_slot -= 1

	for i in range(inventory.hotbar_size):
		if Input.is_action_just_released("hotbar_" + str(i+1)):
			inventory.selected_slot = i

	# toggle inventory
	if Input.is_action_just_pressed("inventory"):
		shop.set_visible(false)
		inventory_ui.toggle()

	if Input.is_action_just_pressed("space"):
		inventory_ui.set_visible(false)
		shop.toggle()

	if Input.is_action_just_pressed("close_menu"):
		inventory_ui.set_visible(false)
		shop.set_visible(false)

	move_and_slide()

func shoot(shoot_ang: float, weapon: ProjectileType) -> void:
	weapon.create(global_position, shoot_ang, allience)

func interact() -> Interactible.InteractionResult:
	var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
	Util.sort_by_distance_asc(self, areas)

	# filter out interactibles
	var interactibles: Array[Interactible] = []
	for area in areas:
		if area is Interactible:
			interactibles.append(area)

	# try to interact with the closest interactible, if passed, try the next one
	for interactible in interactibles:
		var res: Interactible.InteractionResult = interactible.interact(self, inventory.get_selected_item())
		if res == Interactible.InteractionResult.CONSUME:
			inventory.remove_item(inventory.selected_slot, 1)
		if res != Interactible.InteractionResult.PASS:
			return res

	return Interactible.InteractionResult.PASS

func is_gui_open() -> bool:
	return inventory_ui.visible or shop.visible

func take_damage(damage: int) -> void:
	health.damage(damage)

func apply_stun(time: float):
	Emote.create_emote(Emote.EmoteType.STUN, self)
	stun = time


func _on_inventory_on_selected_slot_changed() -> void:
	var item: Item = inventory.get_selected_item()
	if item == null:
		return
	if item is ProjectileType:
		shooting_cooldown.wait_time = item.cooldown


func _on_health_on_zero() -> void:
	if not Global.main.endless_mode:
		Global.main.lose()
