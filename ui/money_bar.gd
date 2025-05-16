extends Label

@export var money_manager: MoneyManager

func _ready() -> void:
	money_manager.on_change.connect(on_money_change)
	on_money_change()

func on_money_change(_previous: int = 0, _new: int = 0) -> void:
	text = "Money: " + str(money_manager.value)
	if Global.main == null or not Global.main.endless_mode:
		text += " / " + str(Global.money_goal)

func _on_main_on_endless_enter() -> void:
	on_money_change()
