extends Gun

class_name MailThrow

@onready var preload_mail = preload("res://mail_projectile.tscn")
var mail: MailProjectile

var mail_remaining = 5


var can_throw = true

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_cooldown = 0.2
	$Timer.timeout.connect(on_timeout)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func shoot():
	if player.mail_remaining > 0 and can_throw and not player.is_on_wall() and !$Node2D/Area2D.has_overlapping_bodies():
		player.mail_remaining -= 1
		$AudioStreamPlayer2D.play(0)
		mail = preload_mail.instantiate()
		mail.apply_impulse((Vector2.RIGHT * 400).rotated(global_rotation))
		mail.apply_force(player.velocity)
		mail.apply_torque_impulse(randf_range(0, 8))
		mail.global_position = $Node2D.global_position
		get_tree().get_first_node_in_group("Level").add_child(mail)
		can_throw = false
		$Timer.start(shot_cooldown)

func on_timeout():
	can_throw = true

func switch_out():
	pass

func switch_in():
	pass
