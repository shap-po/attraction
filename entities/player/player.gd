extends CharacterBody2D

const speed = 50
const weight = 0.4
var health = 3
var allience = "player"

signal healthZERO

var direction = Vector2.ZERO
@onready var current_weapon = load("res://assets/resources/projectiles/shoe.tres") as ProjectileType
@onready var PROJECTILE = preload("res://entities/projectile/projectile.tscn")
@onready var shooting_cooldown: Timer = $shooting_cooldown
@onready var dummy = %dummy

var shoot_r: bool = true


func _ready():
	shooting_cooldown.wait_time = current_weapon.cooldown

func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity != Vector2.ZERO:
		rotation = lerp_angle(rotation, velocity.angle(), weight)
	
	if (Input.is_action_pressed("space")) and (shoot_r == true):
		shoot_r = false
		shooting_cooldown.start()
		shoot()
	move_and_slide()

func shoot():
	var projectile = preload("res://entities/projectile/projectile.tscn")
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = self.global_position
	new_projectile.global_rotation = self.global_rotation
	new_projectile.allience = "player"
	new_projectile.res = current_weapon
	dummy.add_child(new_projectile)
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		healthZERO.emit()

func _on_shooting_cooldown_timeout() -> void:
	shoot_r = true
