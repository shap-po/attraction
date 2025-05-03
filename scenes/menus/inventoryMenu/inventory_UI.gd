extends Control

func _ready() -> void:
	visible = false

#opens and closes inventory	
func _on_player_toggle_inventory() -> void:
	if visible:
		visible = false
	else:
		visible = true
