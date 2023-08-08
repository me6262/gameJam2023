extends State

class_name AlienDead

@export var enemy: CharacterBody2D
@export var animation_player: AnimationPlayer

func Enter():
	animation_player.play("alien_die")

func Update(_delta: float):
	enemy.velocity.x = 0
	
