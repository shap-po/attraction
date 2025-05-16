@tool # to automatically assign the inventory in editor
extends Control

@export var player_inventory: PlayerInventory:
	set(val):
		player_inventory = val
		if shop_invenotry_grid != null:
			shop_invenotry_grid.player_inventory = player_inventory
		if sell_invenotry_grid != null:
			sell_invenotry_grid.inventory = player_inventory

@onready var shop_invenotry_grid: ShopInventoryGrid = $menuWindowTemplateBig/MarginContainer/PanelContainer/MarginContainer/HSplitContainer/items/MarginContainer/TabContainer/Shop/ShopInvenotryGrid
@onready var sell_invenotry_grid: SellInventoryGrid = $menuWindowTemplateBig/MarginContainer/PanelContainer/MarginContainer/HSplitContainer/items/MarginContainer/TabContainer/Inventory/SellInvenotryGrid

func _ready() -> void:
	visible = false

func toggle() -> void:
	set_open(not visible)

func set_open(value: bool) -> void:
	visible = value
