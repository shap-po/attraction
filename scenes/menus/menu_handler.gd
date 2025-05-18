extends Node
class_name MenuHandler

@onready var game_over_menu: GameOverScreen = $GameOverMenu
@onready var shop: Menu = $shop
@onready var inventory_ui: Menu = $inventory_UI
@onready var pause_menu: Menu = $PauseMenu

@onready var menus: Array[Menu] = []

func _ready() -> void:
	menus.append(shop)
	menus.append(inventory_ui)
	menus.append(pause_menu)

func _process(_delta: float) -> void:
	# don't process input if on game over screen
	if game_over_menu.visible:
		return

	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		return
	# only way out of pause menu is to close it
	if pause_menu.visible:
		return

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
		return
	if Input.is_action_just_pressed("space"):
		toggle_shop()
		return

func toggle_menu(menu: Menu) -> void:
	for m in menus:
		if m == menu:
			m.toggle()
		else:
			m.close()

func close_all() -> void:
	for m in menus:
		m.close()

func is_any_open() -> bool:
	for m in menus:
		if m.visible:
			return true
	return false

func toggle_shop() -> void:
	toggle_menu(shop)

func toggle_inventory() -> void:
	toggle_menu(inventory_ui)

func toggle_pause() -> void:
	toggle_menu(pause_menu)
