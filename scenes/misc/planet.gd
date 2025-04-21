extends Node2D

var gravity = 10
var range = 100

@onready var collision_planet_shape: CollisionShape2D = $collision_planet/collision_planet_shape
@onready var gravity_range_shape: CollisionShape2D = $gravity_range/gravity_range_shape


func _ready() -> void:
	var range_c : CircleShape2D
	range_c.radius = range
	gravity_range_shape.shape = range_c
	
	


func _on_gravity_range_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
