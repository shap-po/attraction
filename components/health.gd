class_name Health
extends Resource

signal on_damage(amount: int)
signal on_heal(amount: int)
signal on_change(previous: int, new: int)
signal on_zero()
signal on_maximum_change(previous: int, new: int)

var value: int:
	set(val):
		var prev: int = value
		value = clamp(val, 0, max_value)
		if prev == value:
			return

		on_change.emit(prev, value)
		if value <= 0:
			on_zero.emit()

var max_value: int:
	set(val):
		var prev: int = max_value
		max_value = val
		if prev == max_value:
			return

		on_maximum_change.emit(prev, max_value)
		if value > val:
			value = val


func _init(current: int, maximum: int = -1) -> void:
	assert(current >= 0, "Helath must be positive!")
	if maximum == -1:
		maximum = current
	assert(maximum > 0, "Maximum health must be greater than zero!")

	max_value = maximum
	value = current

func damage(amount: int) -> void:
	assert(amount >= 0, "Amount must be positive!")
	value = value - amount
	on_damage.emit(amount)

func heal(amount: int) -> void:
	assert(amount >= 0, "Amount must be positive!")
	value = value + amount
	on_heal.emit(amount)
