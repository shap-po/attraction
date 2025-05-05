extends Interactible

@onready var talking_box: TalkingBox = $"../UICanvasLayer/talking_box"
@onready var spawner: Spawner = %Spawner

@onready var animation: AnimatedSprite2D = $Animation
@onready var alert: Sprite2D = $Alert
var anim: bool = false

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

func _ready() -> void:
	animation.play()

func toggle_animation():
	if anim == true:
		animation.pause()
		anim = false
	else:
		animation.play()
		anim = true

func interact(player: Player, item: Item) -> InteractionResult:
	alert.visible = false
	if spawner.wave_location == null or spawner.wave_enemies.size() == 0:
		talking_box.show_text("Next wave in " + str(int(spawner.next_wave_timer.time_left)) + " seconds")
	else:
		talking_box.show_text("Bugs are comming from " + enum_to_text(spawner.wave_location) + " in " + str(int(spawner.next_wave_timer.time_left)) + " seconds")
	return InteractionResult.SUCCESS


func _on_spawner_incoming_wave(_wave_location: WeightedEnemy.SpawnArea, _bug_allert_timeout: int) -> void:
	alert.visible = true
