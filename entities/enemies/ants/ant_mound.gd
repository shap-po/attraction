extends Puppet
class_name AntMound

@export var size: int = 1

signal brain_ant_damaged(type: Ant.AntType)
signal brain_ant_killed(type: Ant.AntType)

var allience: String = "bug"
var sprite_texture: Array = [preload("res://assets/textures/enemies/ants/ant_mound_small.png"), preload("res://assets/textures/enemies/ants/ant_mound_medium.png"), preload("res://assets/textures/enemies/ants/ant_mound_big.png")]
@onready var add_ant_points: Timer = $add_ant_points

const ANT: Array = [preload("res://entities/enemies/ants/ant_worker.tscn"), preload("res://entities/enemies/ants/ant_warrior.tscn")]
@onready var ants: Node2D = $ants
@export var max_workers: Array[int] = [5, 8, 12]
@export var max_warrior: Array[int] = [2, 4, 6]
@export var ant_points_recharge_speed: Array[float] = [12.0, 8.0, 6.0]

@export var max_ant_points: Array[int] = [16, 24, 32]
@export var ant_cost: Array[int] = [1, 3]
var current_ants: Array[int] = [0, 0]
var ant_points: int

func _ready() -> void:
	health = Health.new(1)
	health.on_zero.connect(on_zero_health)
	ant_points = max_ant_points[size]
	add_ant_points.wait_time = ant_points_recharge_speed[size]
	add_ant_points.start()

func summon_ant(type: Ant.AntType) -> void:
	if (ant_points >= ant_cost[type]):
		var new_ant: Ant = ANT[type].instantiate()
		ants.add_child(new_ant)
		new_ant.global_position = self.global_position
		new_ant.home = self
		new_ant.enter_home.connect(on_ant_returned)
		new_ant.ant_killed.connect(on_ant_killed)
		new_ant.ant_damaged.connect(on_ant_damaged)
		current_ants[type] += 1
		ant_points -= ant_cost[type]

func on_ant_killed(type: Ant.AntType):
	current_ants[type] -= 1
	brain_ant_killed.emit(type)

func on_ant_damaged(type: Ant.AntType):
	brain_ant_damaged.emit(type)

func on_ant_returned(type: Ant.AntType):
	current_ants[type] -= 1
	ant_points += ant_cost[type]

func _on_add_ant_points_timeout() -> void:
	if ant_points <= max_ant_points[size]:
		ant_points += 1
		add_ant_points.start()

func take_damage(damage: int) -> void:
	pass
