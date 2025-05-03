extends Control

@export var inventory_grid: InventoryGrid

func _ready() -> void:
	visible = false

#opens and closes inventory
func _on_player_toggle_inventory() -> void:
	if visible:
		visible = false
		inventory_grid.on_close()
	else:
		inventory_grid.on_open()
		visible = true
