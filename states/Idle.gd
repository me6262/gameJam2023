extends State

@export var animation_player: AnimationPlayer
@export var enemy: CharacterBody2D
@export var sprite: Sprite2D
@export var gun_point: Gun
var player: CharacterBody2D

@export var floor_check:RayCast2D

var wander_time: float
var move_direction: int

var move_speed = 12
var max_move_speed = 15

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	# animation_player.play("idle")
	if enemy is Gman:
		enemy.died.connect(func(): Transitioned.emit(self, "dead"))

func randomize_wander():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range(3, 7)

func Update(delta: float):
	
	if enemy is Gman:
		if enemy.dead:
			Transitioned.emit(self, "dead")
	
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

	if abs(enemy.velocity.x) < move_speed:
		enemy.velocity.x += move_speed * move_direction
	else:
		enemy.velocity = enemy.velocity.slerp(Vector2.ZERO, 0.5)


	if !floor_check.is_colliding() and enemy.is_on_floor() or enemy.is_on_wall():
		move_direction *= -1
	
	if move_direction == 1:
		# animation_player.play("walk")
		sprite.flip_h = false
		floor_check.position.x = abs(floor_check.position.x)
	elif move_direction == -1:
		# animation_player.play("walk")
		sprite.flip_h = true
		floor_check.position.x = abs(floor_check.position.x) * -1
	else:
		# animation_player.play("idle")
		enemy.velocity = enemy.velocity.slerp(Vector2.ZERO, 0.5)
	
	if enemy.global_position.distance_to(player.global_position) < 20:
		Transitioned.emit("Hostile")




func Physics_Update(delta: float):
	if enemy:
		if enemy.is_on_floor():

			if abs(enemy.velocity.x) > max_move_speed:
				enemy.velocity.x = lerpf(enemy.velocity.x, max_move_speed, 0.5)
			else:
				enemy.velocity.x += move_direction * move_speed


