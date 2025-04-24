extends CharacterBody2D
class_name ant_mound

@export var size: int = 1

signal brain_ant_damaged
signal brain_ant_killed

var allience = "bug"
var sprite_texture: Array = [preload("res://assets/textures/enemies/ants/ant_mound_small.png"), preload("res://assets/textures/enemies/ants/ant_mound_medium.png"), preload("res://assets/textures/enemies/ants/ant_mound_big.png")]
@onready var brain: StateMachine = $brain

const ANT: Array = [preload("res://entities/enemies/ants/ant_worker.tscn"), preload("res://entities/enemies/ants/ant_warrior.tscn")]
@onready var ants: Node2D = $ants

var max_workers: Array[int] = [5, 8, 12]
var max_warrior: Array[int] = [2, 4, 6]

var max_ant_points = [16, 24, 32]
var ant_cost = [1, 3]


var current_ants: Array[int] = [0, 0]
var ant_points: int

func _ready() -> void:
	ant_points = max_ant_points[size]
	
func _physics_process(delta: float) -> void:
	if (current_ants[0] < max_workers[size]) && (ant_points >= ant_cost[0]):
		summon_ant(0)
	
func summon_ant(type: int):
	var new_ant = ANT[type].instantiate()
	ants.add_child(new_ant)
	new_ant.global_position = self.global_position 
	new_ant.home = self
	new_ant.ant_killed.connect(on_ant_killed)
	new_ant.ant_damaged.connect(on_ant_damaged)
	current_ants[type] += 1
	ant_points -= ant_cost[type]

func take_damage(dmg):
	pass

func on_ant_killed(ant: Node2D):
	brain_ant_killed.emit()
func on_ant_damaged(ant: Node2D):
	brain_ant_damaged.emit()
