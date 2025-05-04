@tool
extends Control

@export var player_inventory: PlayerInventory:
	set(val):
		player_inventory = val
		if shop_invenotry_grid != null:
			shop_invenotry_grid.player_inventory = player_inventory
		if player_invenotry_grid != null:
			player_invenotry_grid.inventory = player_inventory

@onready var shop_invenotry_grid: ShopInventoryGrid = $menuWindowTemplateBig/MarginContainer/PanelContainer/MarginContainer/HSplitContainer/items/MarginContainer/TabContainer/Shop/ShopInvenotryGrid
@onready var player_invenotry_grid: PlayerInventoryGrid = $menuWindowTemplateBig/MarginContainer/PanelContainer/MarginContainer/HSplitContainer/items/MarginContainer/TabContainer/Inventory/PlayerInvenotryGrid

func _ready() -> void:
	visible = false

func toggle() -> void:
	visible = not visible
