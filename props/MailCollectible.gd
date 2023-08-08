extends Node2D

class_name MailCollectible

var player: Player

signal collected

var collecting = false
var player_in_range = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(collect)
	$Area2D.body_exited.connect(on_body_exited)
	$AnimationPlayer.play("bob")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		if player.mail_remaining < player.max_mail:
			if global_position - player.global_position >= Vector2(8, 8):
				global_position = global_position.slerp(player.global_position, 0.3)
			elif not collecting:
				print("mail collected")
				$collect.play(0)
				$collect.finished.connect(on_collect_finished)
				collecting = true


func collect(body: Node2D):
	if body is Player:
		player = body
func change_mail_type(new_frame: int):
	$Path2D2/PathFollow2D/Path2D/PathFollow2D/Sprite2D.frame = new_frame	

func on_body_exited(body: Node2D):
	if body is Player:
		if not collecting:
			player = null

func on_collect_finished():
	if player:
		player.mail_remaining += 1
		collected.emit()
		queue_free()
