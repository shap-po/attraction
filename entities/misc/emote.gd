extends Sprite2D

@export var speed = 0.1


@export var max_ticks_lifetime: float = 60
var ticks_lifetime: float

func _ready() -> void:
	ticks_lifetime = max_ticks_lifetime

func _process(delta: float) -> void:
	ticks_lifetime -= 1.0
	if ticks_lifetime <= 0:
		end()
		return
	position += Vector2(0,-speed)
	var c = Color(1.0, 1.0, 1.0, ticks_lifetime / max_ticks_lifetime)
	self.modulate = c
	
func end():
	queue_free()	
	
