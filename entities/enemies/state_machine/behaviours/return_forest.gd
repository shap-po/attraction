extends State
class_name ReturnForest

@export var SPEED_MULTIPLIER: float = 0.7

var target_point: Vector2
@onready var map_markers: Node2D = $/root/main/map/map_markers ## it has stupid



var checkout_locations: Array[Marker2D] = []


func on_creation():
	puppet.unconditional_state = "ReturnForest"
	if !map_markers:
		#print("aw hell nah")
		return
	checkout_locations.clear()
	for child in map_markers.get_child(1).get_children(): ## its the fastest way possible, but prone to errors
		if child.visible == true:
			checkout_locations.append(child)
	if puppet == null:
		return
	choose_new_point()
	
func choose_new_point() -> void:
	if !(puppet.target): 
		puppet.target = checkout_locations[0]
		var dis1 = puppet.target.global_position.distance_squared_to(puppet.global_position)
		for loc in checkout_locations:
			var dis2 = loc.global_position.distance_squared_to(puppet.global_position)
			if dis1 < dis2: 
				puppet.target = loc
				dis1 = dis2
		target_point = puppet.target.global_position
		



func procces(_delta) -> void:
	if !target_point:
		choose_new_point()
		return
	if target_point.distance_squared_to(puppet.global_position) < 50:
		puppet.target = null
		puppet.queue_free()
		return
	puppet.velocity = puppet.speed * SPEED_MULTIPLIER * puppet.global_position.direction_to(target_point)
