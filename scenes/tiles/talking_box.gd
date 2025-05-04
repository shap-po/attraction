extends Control

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

func show_text(text_length):
	is_talking = true
	sound.play()
	label.visible_characters = 0
	while label.visible_characters < text_length:
		await get_tree().create_timer(0.05).timeout
		label.visible_characters += 1
	is_talking = false
	print("end")

func update():
	show_text(label.get_total_character_count())
	visible = true
	await get_tree().create_timer(8.0).timeout
	visible = false

func enum_to_text(wave_location: WeightedEnemy.SpawnArea) -> String:
	match wave_location:
		WeightedEnemy.SpawnArea.TOP:
			return "North"
		WeightedEnemy.SpawnArea.BOTTOM:
			return "South"
		WeightedEnemy.SpawnArea.RIGHT:
			return "East"
		WeightedEnemy.SpawnArea.LEFT:
			return "West"
		WeightedEnemy.SpawnArea.FARM:
			return "Farm"
	return "Error"

func _on_spawner_incoming_wave(wave_location: WeightedEnemy.SpawnArea, bug_allert_timeout: int) -> void:
	print("incoming wave signal recieved!")
	var new_text: String
	new_text = "Bugs are comming from " + enum_to_text(wave_location) + " in " + str(bug_allert_timeout) + " seconds"
	label.text = new_text
	update()


func _on_audio_stream_player_2d_finished() -> void:
	if is_talking == true:
		var index = randi() % sounds.size()
		sound.stream = sounds[index]
		sound.play()
	
