extends Menu

@export var inventory_grid: BaseInventoryGrid

func _on_open() -> void:
	inventory_grid.on_open()

func _on_close() -> void:
	inventory_grid.on_close()
