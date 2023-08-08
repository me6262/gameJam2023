extends Node2D

class_name Gun

@export var player: Player
var knockback = 200
var clip_size = 10
var reload_time_seconds = 1
var bullets_left: int
var shot_cooldown = 0.2
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	pass

func reload():
	pass

func switch_out():
	pass

func switch_in():
	pass

