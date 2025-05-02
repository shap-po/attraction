extends Node
class_name Health

signal on_damage(amount: int)
signal on_heal(amount: int)
signal on_change(previous: int, new: int)
signal on_zero()
signal on_maximum_change(previous: int, new: int)

@export_range(0, 100, 1, "or_greater") var value: int:
	set(val):
		var prev: int = value
		value = clamp(val, 0, max_value) if max_value > 0 else max(0, val)
		if prev == value:
			return

		on_change.emit(prev, value)
		if value <= 0:
			on_zero.emit()

var max_value: int = -1:
	set(val):
		var prev: int = max_value
		max_value = val
		if prev == max_value:
			return

		on_maximum_change.emit(prev, max_value)
		if value > val:
			value = val

func _ready() -> void:
	max_value = value

func damage(amount: int) -> void:
	assert(amount >= 0, "Amount must be positive!")
	value = value - amount
	on_damage.emit(amount)

func heal(amount: int) -> void:
	assert(amount >= 0, "Amount must be positive!")
	value = value + amount
	on_heal.emit(amount)

## Returns health as percentage (0.0 - 1.0)
func as_float() -> float:
	if max_value <= 0:
		return 1.0
	return float(value) / max_value
