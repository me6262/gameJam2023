extends RigidBody2D

class_name EnemyGun

var can_shoot = false
var shot_cooldown = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(shoot_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if can_shoot:
		shoot()
		can_shoot = false
	else:
		$Timer.start(shot_cooldown)


func shoot_timer_timeout():
	can_shoot = true

func shoot():
	print("shooting")
	apply_impulse(Vector2.UP * 20)

