extends Node
class_name MoneyManager

signal on_change(previous: int, new: int)

var value: int = 0:
	set(val):
		var previous: int = value
		value = val
		on_change.emit(previous, val)
		if value >= Global.money_goal and not Global.main.endless_mode:
			Global.main.menu_handler.game_over_menu.open_win()

func add(amount: int) -> void:
	value += amount

func remove(amount: int) -> bool:
	if value - amount < 0:
		return false

	value -= amount
	return true
