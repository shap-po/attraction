extends Ant
class_name AntWarrior

func _ready() -> void:
	type = AntType.WARRIOR
	weight = 0.4
	health = Health.new(5)
	speed = 15

	health.on_zero.connect(on_zero_health)
