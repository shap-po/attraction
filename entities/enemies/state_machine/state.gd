extends Node
class_name State

signal Transitioned_signal

var puppet: Node2D
var first_iteration: bool = true

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
func create_emote(type: EmoteType):
	var new_emote: Sprite2D = Emote_node.instantiate()
	new_emote.texture = emote_dict[type]
	puppet.add_child(new_emote)
	new_emote.global_position = puppet.global_position

func enter():
	pass

func exit():
	pass
	
func fprocces():
	if first_iteration: # this shit so ass, im sorry
		first_iteration = false
		on_creation()
		pass
	procces()
	
func procces():
	pass

func on_creation():
	pass
