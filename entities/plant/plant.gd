extends Node2D
class_name Plant

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var plant_type: PlantType

signal on_growth_stage_change(previous: int, new: int)
signal on_fully_grown()

var growth_ticks: int
var growth_ticks_per_stage: float
var last_growth_stage: int
var current_growth_stage: int = 0


func _ready() -> void:
	sprite_2d.texture = plant_type.grow_stages[0]
	last_growth_stage = plant_type.grow_stages.size() - 1
	growth_ticks_per_stage = plant_type.growTime / last_growth_stage


func _on_growth_timer_timeout() -> void:
	growth_ticks += 1
	var prev_stage: int = current_growth_stage
	current_growth_stage = min(growth_ticks / growth_ticks_per_stage, last_growth_stage)
	if prev_stage == current_growth_stage:
		return

	sprite_2d.texture = plant_type.grow_stages[current_growth_stage]
	on_growth_stage_change.emit(prev_stage, current_growth_stage)

	if current_growth_stage == last_growth_stage:
		on_fully_grown.emit()
		$GrowthTimer.stop()
