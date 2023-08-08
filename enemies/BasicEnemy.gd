extends CharacterBody2D

class_name Enemy

@export var max_health = 10
var health: int
var move_speed: int
var acceleration: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hurt(_damage: int, _source: Vector2):
	pass

func attack():
	pass
