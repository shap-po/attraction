extends Control
class_name TalkingBox

@onready var spawner: Spawner = %Spawner
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var label: Label = $PanelContainer/MarginContainer/Label
@onready var is_talking: bool = false
@export var sounds: Array[AudioStream]
@export var npc: NPC

func _ready() -> void:
	visible = false
	#label.set_visible_characters(0)
	pass

func talking():
	pass

func play_sound():
	pass

func _show_text(text_length):
	is_talking = true
	sound.play()
	label.visible_characters = 0
	while label.visible_characters < text_length:
		await get_tree().create_timer(0.05).timeout
		label.visible_characters += 1
	is_talking = false
	print("end")

func show_text(text: String):
	label.text = text
	_show_text(label.get_total_character_count())
	visible = true
	await get_tree().create_timer(8.0).timeout
	visible = false


func _on_audio_stream_player_2d_finished() -> void:
	if is_talking == true:
		var index = randi() % sounds.size()
		sound.stream = sounds[index]
		sound.play()
