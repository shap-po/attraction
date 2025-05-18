extends Menu
class_name GameOverScreen

@onready var title: Label = $VBoxContainer/Title
@onready var subtitle: Label = $VBoxContainer/Subtitle
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var endless: Button = $VBoxContainer/Endless
@onready var quit_button: Button = $VBoxContainer/QuitButton

func open_lost_timer_ended() -> void:
	title.text = "Game Over"
	subtitle.text = "Time's up!"
	start_button.text = "Restart"
	open()

func open_lost_death() -> void:
	title.text = "Game Over"
	subtitle.text = "You died!"
	start_button.text = "Restart"
	open()

func open_win() -> void:
	title.text = "You Win!"
	subtitle.text = "Thanks for playing!"
	start_button.text = "Play Again"
	open()

func _on_open() -> void:
	Global.pause_game()

func _on_close() -> void:
	Global.unpause_game()

func _on_start_button_pressed() -> void:
	Global.unpause_game() # otherwise the game will still be paused
	get_tree().reload_current_scene()

func _on_endless_pressed() -> void:
	Global.main.set_endless()
	close()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
