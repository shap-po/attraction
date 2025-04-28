extends Ant
class_name AntWorker

func _ready() -> void:
	type = AntType.WORKER
	weight = 0.4
	health = Health.new(1)
	speed = 20

	health.on_zero.connect(on_zero_health)
