extends Label

@onready var time_left_timer: Timer = $"../../TimeLeftTimer"

func _process(delta: float) -> void:
	var seconds: int = int(time_left_timer.time_left)
	var time: String
	if seconds > 60:
		time = str(seconds / 60) + " min"
	else:
		time = str(seconds) + " sec"
	text = "Time left: " + time
