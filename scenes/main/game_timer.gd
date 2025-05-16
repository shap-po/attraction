extends Timer
class_name GameTimer

signal on_game_over()

var time_passed: int = 0 ## In seconds
@export_range(0, 10_000) var time_till_game_over: int = 360 ## In seconds

func _on_timeout() -> void:
	time_passed += 1
	time_till_game_over -= 1
	if time_till_game_over == 0:
		on_game_over.emit()
