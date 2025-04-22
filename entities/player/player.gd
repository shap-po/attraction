extends CharacterBody2D

const speed = 50
const weight = 0.4
var allience = "player"
var direction = Vector2.ZERO
var health: Health = Health.new(5)

@onready var current_weapon = load("res://assets/resources/projectiles/shoe.tres") as ProjectileType
@onready var PROJECTILE = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var player_sprite: Sprite2D = $player_sprite
@onready var dummy = %dummy

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
	move_and_slide()

func shoot(shoot_ang):
	var projectile = preload("res://entities/projectile/projectile.tscn")
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = shoot_ang
	new_projectile.allience = "player"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)


func _on_shooting_cooldown_timeout() -> void:
	shoot_r = true
