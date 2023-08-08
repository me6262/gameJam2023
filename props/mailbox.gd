extends Node2D

class_name Mailbox

signal mail_recieved

@export var mail_required = 1
var player: CharacterBody2D
var mail: MailProjectile

var mail_delivered_total = 0

var delivered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "%d/%d" % [mail_delivered_total, mail_required]
	if mail_delivered_total >= mail_required and not delivered:
		delivered = true

		print("mail full")
		await get_tree().create_timer(1).timeout
		mail_recieved.emit()

func on_body_entered(body: Node2D):
	if body is MailProjectile:
		mail = body
		mail.mailbox = self
		print("hit")
		mail_delivered_total += 1
		
	
func on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		player = null
