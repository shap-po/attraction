extends TextureRect

const DEFAULT_TEXTURE: Texture2D = preload("res://assets/textures/moth/Moth girl.png")
const CLICKED_TEXTURE: Texture2D = preload("res://assets/textures/moth/Moth girl closed eyes.png")

@onready var click_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var revert_timer: Timer = $Timer

func _on_button_pressed() -> void:
	texture = CLICKED_TEXTURE
	click_sound.play()
	revert_timer.start()

func _on_timer_timeout() -> void:
	texture = DEFAULT_TEXTURE
