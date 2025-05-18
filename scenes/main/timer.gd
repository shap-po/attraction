extends Label

@onready var game_timer: GameTimer = $"../../GameTimer"

func _process(_delta: float) -> void:
	if not Global.main.endless_mode:
		text = "Time left: " + time_to_str(game_timer.time_till_game_over)
	else:
		text = "Time played: " + time_to_str(game_timer.time_passed)

func time_to_str(seconds: int) -> String:
	if seconds > 60:
		@warning_ignore("integer_division")
		return str(seconds / 60) + " min"
	return str(seconds) + " sec"
