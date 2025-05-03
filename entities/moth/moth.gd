extends TextureRect

@export var default_texture: Texture2D = load("res://assets/textures/moth/Moth girl.png")
@export var clicked_texture: Texture2D = load("res://assets/textures/moth/Moth girl closed eyes.png")

@onready var click_sound = $AudioStreamPlayer2D

var revert_timer := Timer.new()

func _ready():
	texture = default_texture

	# Set up the timer
	revert_timer.wait_time = 1.0
	revert_timer.one_shot = true
	revert_timer.timeout.connect(_on_revert_texture)
	add_child(revert_timer)
	
	# Optional: if you want to handle mouse click manually
	set_mouse_filter(Control.MOUSE_FILTER_STOP)
	connect("gui_input", _on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		texture = clicked_texture
		click_sound.play()
		revert_timer.start()

func _on_revert_texture():
	texture = default_texture
