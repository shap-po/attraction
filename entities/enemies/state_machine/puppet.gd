extends CharacterBody2D
class_name Puppet

@onready var brain: StateMachine = $brain
@onready var timer: Timer = $timer
var health: Health
var speed: float
