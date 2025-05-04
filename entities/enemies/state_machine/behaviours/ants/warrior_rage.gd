extends State
class_name WarriorRage

func on_creation():
	Emote.create_emote(Emote.EmoteType.ANGRY, self)
