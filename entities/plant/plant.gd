extends Area2D
class_name Plant

var allience = "player"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var growth_timer: Timer = $GrowthTimer
@onready var health: Health = $Health
@export var plant_type: PlantType

signal on_growth_stage_change(previous: int, new: int)
signal on_fully_grown()
signal on_before_remove() ## Emitted when the plant is marked for deletion

var plot: Plot
var growth_ticks: int
var growth_ticks_per_stage: float
var last_growth_stage: int
var current_growth_stage: int = 0

var times_harvested: int = 0


func _ready() -> void:
	assert(plant_type != null, "Plant '" + self.to_string() + "' initialised with plant_type = null")
	_update_texture()
	last_growth_stage = plant_type.grow_stages.size() - 1
	health.max_value = plant_type.health
	health.value = plant_type.health
	@warning_ignore("integer_division")
	growth_ticks_per_stage = plant_type.grow_time / last_growth_stage


func _on_growth_timer_timeout() -> void:
	growth_ticks += 1
	var prev_stage: int = current_growth_stage
	current_growth_stage = min(growth_ticks / growth_ticks_per_stage, last_growth_stage)
	if prev_stage == current_growth_stage:
		if current_growth_stage == last_growth_stage and plant_type.invasion_chance > 0:
			invade()
		return

	_update_texture()
	on_growth_stage_change.emit(prev_stage, current_growth_stage)

	if current_growth_stage == last_growth_stage:
		on_fully_grown.emit()
		# Remove the timer if no longer needed
		if plant_type.invasion_chance == 0:
			growth_timer.stop()

func _update_texture() -> void:
	sprite_2d.texture = plant_type.grow_stages[current_growth_stage]

func is_fully_grown() -> bool:
	return current_growth_stage == last_growth_stage

func invade() -> void:
	if randf() > plant_type.invasion_chance:
		return
	for sibling_plot in plot.siblings:
		if sibling_plot.plant == null:
			sibling_plot.create_plant(plant_type)
			return

func create_crop() -> Item:
	# The more damaged the plant is, the less quality the crop will have
	# final range: 0.5 - 1.0
	var quality: float = health.as_float() * 0.5 + 0.5

	var crop: Item = Item.new()
	crop.item_name = plant_type.crop_name
	crop.item_texture = plant_type.fruit_item_texture
	@warning_ignore("narrowing_conversion")
	crop.sell_price = plant_type.grown_sell_price * quality
	return crop

func harvest() -> Item:
	if not is_fully_grown():
		return null

	var crop: Item = create_crop()
	times_harvested += 1
	if plant_type.crop_type == PlantType.CropType.BUSH and (plant_type.bush_harvest_limit == 0 or times_harvested < plant_type.bush_harvest_limit):
		# remove growth stages
		@warning_ignore("narrowing_conversion")
		growth_ticks -= plant_type.bush_stages_per_harvest * growth_ticks_per_stage
		current_growth_stage = max(current_growth_stage - plant_type.bush_stages_per_harvest, 0)
		_update_texture()
		on_growth_stage_change.emit(current_growth_stage, current_growth_stage)

		# restart growth timer
		growth_timer.start()
	else:
		queue_free()
		on_before_remove.emit()

	return crop

func take_damage(damage: int) -> void:
	health.damage(damage)

func _on_health_on_zero() -> void:
	queue_free()
	on_before_remove.emit()
