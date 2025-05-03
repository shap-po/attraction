extends TextureProgressBar

@export var health: Health

func _ready() -> void:
	health.on_change.connect(update)
	update()
	
func update(_new: int = 0, _previous: int = 0):
	value = health.as_float() * 100
