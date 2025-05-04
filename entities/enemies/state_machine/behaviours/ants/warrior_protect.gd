extends State
class_name WarrirProtect

func on_creation():
	Emote.create_emote(Emote.EmoteType.WARNING, self)
