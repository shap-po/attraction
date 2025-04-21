extends CharacterBody2D

var speed = 300

func _physics_process(_delta):
	var direction = Vector2(0, -1)
	velocity = direction * speed
	
	if velocity != Vector2.ZERO:
		rotation = lerp_angle(rotation, velocity.angle(), 0.5)
		
	move_and_slide()
