extends Gun

class_name Pistol
var time_since_shot: float = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	knockback = 100
	bullets_left = clip_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_shot += delta

func shoot():
	if time_since_shot > shot_cooldown:
		bullets_left -= 1	
		if bullets_left > 0:
			time_since_shot = 0
			var force = Vector2.LEFT.rotated(global_rotation) * knockback
			player.velocity += force
		else:
			reload()

func reload():
	# put anim stuff here as well i guess

	await get_tree().create_timer(reload_time_seconds).timeout

	bullets_left = clip_size

func switch_out():
	pass

func switch_in():
	pass
