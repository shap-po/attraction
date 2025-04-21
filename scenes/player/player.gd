extends CharacterBody2D

var acceleration = 10
var friction = 5
var speed = 0
var agility = deg_to_rad(0)

var direction = Vector2(1, 0)

func _physics_process(_delta):
	
	if Input.is_action_pressed("forwards"):
		speed += acceleration
	if Input.is_action_pressed("steerleft"):
		self.rotation -= agility
	if Input.is_action_pressed("steerright"):
		self.rotation += agility
	
	if (speed != 0):
		if (speed >= 0):
			speed -= friction
		if (speed <= 0):
			speed += friction
		if (abs(speed) <= friction) && (!Input.is_action_pressed("forwards")):
			speed = 0
			
	velocity = speed * Vector2(1, 0).rotated(rotation)	
	move_and_slide()
