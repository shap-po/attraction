extends Sprite2D
class_name Emote


@export var speed: float = 0.1
@export var max_ticks_lifetime: float = 60
var ticks_lifetime: float
var direction = Vector2.UP

func _ready() -> void:
	ticks_lifetime = max_ticks_lifetime

func _process(_delta: float) -> void:
	ticks_lifetime -= 1.0
	if ticks_lifetime <= 0:
		end()
		return
	position += (direction * speed)
	var c: Color = Color(1.0, 1.0, 1.0, ticks_lifetime / max_ticks_lifetime)
	self.modulate = c

func end():
	queue_free()

const Emote_node: PackedScene = preload("res://entities/misc/emote.tscn")
const emote_dict: Dictionary = {
	EmoteType.ALERT: preload("res://assets/textures/misc/emotes/alert.png"),
	EmoteType.ANGRY: preload("res://assets/textures/misc/emotes/angry.png"),
	EmoteType.QUESTION: preload("res://assets/textures/misc/emotes/question.png"),
	EmoteType.WARNING: preload("res://assets/textures/misc/emotes/warning.png"),
	EmoteType.STUN: preload("res://assets/textures/misc/emotes/stun.png"),
	EmoteType.BITE_LOWER: preload("res://assets/textures/misc/emotes/bite_lower.png"),
	EmoteType.BITE_UPPER: preload("res://assets/textures/misc/emotes/bite_upper.png")
}
enum EmoteType {
	ALERT,
	ANGRY,
	QUESTION,
	WARNING,
	STUN,
	BITE_LOWER,
	BITE_UPPER
}

static func create_emote(type: EmoteType, parent: Node, propagation_direction: Vector2 = Vector2.UP, speed: float = 0.1, pos: Vector2 = parent.global_position, rot: float = 0, follow: bool = true):
	var new_emote: Sprite2D = Emote_node.instantiate()
	new_emote.speed = speed
	new_emote.direction = propagation_direction
	new_emote.texture = emote_dict[type]
	new_emote.rotation = rot
	if follow:
		parent.dummy.add_child(new_emote)
	else:
		parent.get_parent().add_child(new_emote)
	new_emote.global_position = pos
