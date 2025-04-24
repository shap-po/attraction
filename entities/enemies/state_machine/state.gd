extends Node
class_name State

signal Transitioned_signal

var puppet: Node2D
var first_iteration: bool = true

func create_emote(type: Emote.EmoteType):
	Emote.create_emote(type, puppet)
	

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
