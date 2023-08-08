extends State

@export var enemy: Gman
@export var animation_player: AnimationPlayer
@export var gun: EnemyGun


@onready var player: Player = get_tree().get_first_node_in_group("Player")

func Enter():
	# do suprise animation here
	# animation_player.play("alien_idle")
	# gun.look_at(player.global_position)
	pass


func Update(_delta: float):
	pass

