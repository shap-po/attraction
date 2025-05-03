extends Node

signal on_change(previous: int, new: int)

var money: int = 0:
	set(val):
		on_change.emit(money, val)
		money = val

func add(amount: int) -> void:
	money += amount

func remove(amount: int) -> bool:
	if money - amount < 0:
		return false

	money -= amount
	return true
