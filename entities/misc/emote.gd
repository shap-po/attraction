extends Sprite2D
class_name Emote

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
	
const Emote_node: PackedScene = preload("res://entities/misc/emote.tscn")
const emote_dict: Dictionary = {
	EmoteType.ALERT: preload("res://assets/textures/misc/emotes/alert.png"),
	EmoteType.ANGRY: preload("res://assets/textures/misc/emotes/angry.png"),
	EmoteType.QUESTION: preload("res://assets/textures/misc/emotes/question.png"),
	EmoteType.WARNING: preload("res://assets/textures/misc/emotes/warning.png")
}
enum EmoteType {
	ALERT,
	ANGRY,
	QUESTION,
	WARNING
}
static func create_emote(type: EmoteType, parent: Node):
	var new_emote: Sprite2D = Emote_node.instantiate()
	new_emote.texture = emote_dict[type]
	parent.add_child(new_emote)
	new_emote.global_position = parent.global_position
	
