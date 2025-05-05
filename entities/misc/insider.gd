extends Interactible

@onready var main_animation: AnimatedSprite2D = $main_animation
@onready var listen: Sprite2D = $listen
var anim: bool = false


func _ready() -> void:
	main_animation.play()

func toggle_notification():
	if listen.visible == true:
		listen.visible = false
	else:
		listen.visible = true

func toggle_animation():
	if anim == true:
		main_animation.pause()
		anim = false
	else:
		main_animation.play()
		anim = true

func interact(player: Player, item: Item) -> InteractionResult:
	toggle_notification()
	return InteractionResult.PASS
