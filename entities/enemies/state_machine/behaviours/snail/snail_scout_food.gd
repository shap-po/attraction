extends State
class_name SnailScoutFood

@export var SPEED_MULTIPLIER: float = 0.7

var target_point: Vector2
@onready var map_markers: Node2D = $/root/main/map/map_markers ## it has stupid



var checkout_locations: Array[Marker2D] = []


func on_creation():
	puppet.unconditional_state = "SnailScoutFood"
	if !map_markers:
		#print("aw hell nah")
		return
	checkout_locations.clear()
	for child in map_markers.get_child(0).get_children():
		if child.visible == true:
			checkout_locations.append(child)
	if puppet == null:
		return
	choose_new_point()
	
func choose_new_point() -> void:
	if !(puppet.target): puppet.target = checkout_locations.pick_random()
	target_point = puppet.target.global_position
	



func procces(_delta) -> void:
	var areas: Array[Area2D] = puppet.area_sight.get_overlapping_areas()
	if areas:
		for area in areas:
			if area is Plant:
				puppet.target = area
				puppet.brain.force_transition("SnailAttackFood")
	if !target_point:
		return
	if target_point.distance_squared_to(puppet.global_position) < 50:
		puppet.target = null
		choose_new_point()
	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)
