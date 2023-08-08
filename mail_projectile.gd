extends RigidBody2D

class_name MailProjectile

@onready var mail_type: int = randi_range(0, 3)
@onready var damage_dict: Array[int] = [20, 40, 10, 30]
@onready var current_damage = damage_dict[mail_type]
@onready var rand_rotation = randf_range(-3, 8)
var pickup = preload("res://props/MailCollectible.tscn")
var unpacked_pickup: MailCollectible

var stopped = false

var mailbox: Mailbox
var first_hit = false
var starting_rotation: float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = mail_type
	body_entered.connect(on_body_entered)
	$Timer.timeout.connect(on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	

	if mailbox:
		if global_position.distance_to(mailbox.global_position) < 2:
			print("hahahahahah")
			queue_free()
		gravity_scale = 0
		global_position = global_position.slerp(mailbox.global_position, 0.5)
		$Sprite2D.scale = $Sprite2D.scale.lerp(Vector2.ZERO, 0.1)
	
	if linear_velocity.length() < 2 and not stopped:
		stopped = true	
		$Timer.start(1)

func on_body_entered(body: Node2D):
	print("hit")
	if body is Enemy and not first_hit:
		print("enemy")
		body.hurt(current_damage, linear_velocity)
		first_hit = true
	if body is Breakable and not first_hit:
		body.destroy()
		first_hit = true

	#elif body is Player:

func collect_mode():
	freeze = true
	$CollisionShape2D.disabled = true
	unpacked_pickup = pickup.instantiate()
	$Sprite2D.visible = false
	add_child(unpacked_pickup)
	unpacked_pickup.change_mail_type(mail_type)
	unpacked_pickup.global_rotation = 0
	unpacked_pickup.collected.connect(func(): queue_free())


func on_timeout():
	collect_mode()

