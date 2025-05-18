extends Control
class_name Menu

func _ready() -> void:
	visible = false

func _on_open() -> void:
	pass

func _on_close() -> void:
	pass

func set_open(value: bool) -> void:
	if visible == value:
		return

	if value:
		_on_open()
		visible = true
	else:
		visible = false
		_on_close()

func toggle() -> void:
	set_open(not visible)

func open() -> void:
	set_open(true)

func close() -> void:
	set_open(false)
