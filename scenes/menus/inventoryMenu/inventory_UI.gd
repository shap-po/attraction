extends Control

@export var inventory_grid: BaseInventoryGrid

func _ready() -> void:
	visible = false

func toggle() -> void:
	set_open(not visible)

func set_open(value: bool) -> void:
	if visible == value:
		return

	if value:
		inventory_grid.on_open()
		visible = true
	else:
		visible = false
		inventory_grid.on_close()
