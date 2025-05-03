extends Label

func _ready() -> void:
	Money.on_change.connect(on_money_change)
	on_money_change()

func on_money_change(_previous: int = 0, _new: int = 0) -> void:
	text = "Money: " + str(Money.value)
