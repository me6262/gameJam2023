extends Gun

class_name Shotgun

var time_since_shot = 0
var reloading = false
var can_shoot = true
var shooting = true

@onready var bullet_particles: GPUParticles2D = $Sprite2D/Shot

# Called when the node enters the scene tree for the first time.
func _ready():
	knockback = 500
	clip_size = 3
	shot_cooldown = .8
	bullets_left = clip_size
	reload_time_seconds = 3
	damage = 40
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_shot += delta
	if global_rotation_degrees > 90 or  global_rotation_degrees < -90:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
	

	if bullets_left <= 0:
		reload()


func shoot():
	if time_since_shot > shot_cooldown and can_shoot:
		can_shoot = false
		shooting = true
		if bullets_left > 0:
			bullets_left -= 1

			time_since_shot = 0
			
			var force = Vector2.LEFT.rotated(global_rotation) * knockback
			player.velocity += force
			$AnimationPlayer.play("shoot")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("cock_shotgun")
			await $AnimationPlayer.animation_finished
			if bullets_left <= 0:
				reload()
		can_shoot = true
		shooting = false

func reload():
	if not reloading and not shooting:
		reloading = true
		$AnimationPlayer.stop()
		$AnimationPlayer.play("reload_shotgun")
		await $AnimationPlayer.animation_finished
		
		bullets_left = clip_size
		reloading = false

func cocking():
	if reloading == false:
		reloading = true
		$AnimationPlayer.play("reload_shotgun")
		await $AnimationPlayer.animation_finished

func switch_out():
	visible = false

func switch_in():
	visible = true


func check_shotgun_collisions():
	print("wooho")
	for body in $Area2D.get_overlapping_bodies():
		if body is Enemy:
			body.hurt(damage, global_rotation)

