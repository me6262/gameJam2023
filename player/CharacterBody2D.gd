extends CharacterBody2D

class_name Player

signal died
const air_accelerate: int = 15
const accelerate: float = 40
const gravity: int = 980
const max_floor_speed: float = 180
const max_air_speed: float = 190
@onready var collider:CollisionShape2D = $CollisionShape2D
@onready var cam: Camera2D = $Camera2D

const dash_speed: float = 800
const dash_lerp = 18
const jump_velocity = 200
const jump_hold_velocity = 40
const max_jump_held_frames: int = 8
const max_buffered_jump_preframes: int = 2
const total_dash_cooldown: float = 2 #seconds
const default_friction = 20

var gun_rotation = Vector2.ZERO

var max_mail = 5

var was_last_on_floor = true

var is_gamepad_aim = false

var cutscene_mode = false
var allowed_to_jump = true
var allowed_to_dash = true
var mail_remaining: int = 5
var dash_timer: SceneTreeTimer
var jump_frame_counter = 0
var input_axis: float
var dashes_left: int = 1
var dash_lerp_amount = 0

var can_die = false

func _ready():
	$Timer.timeout.connect(on_death_timer_timeout)
	pass

func _process(delta):
	var pos = $GunPoint/MailThrow/Node2D.global_position
	var vel = (Vector2.RIGHT * 3360).rotated($GunPoint/MailThrow.global_rotation) * delta# the velocity of the shot

	if input_axis < 0:
		$Sprite2D.flip_h = true
	elif input_axis > 0:
		$Sprite2D.flip_h = false
	
	if mail_remaining > 0 and Input.is_action_pressed("aim"):
		$Line2D.visible = true
		var num_points = 8 # how many points you want to show

		for i in range(num_points):
			$Line2D.set_point_position(i, pos - global_position)
			vel.y = vel.y + 980 * delta
			pos += vel

		if $GunPoint.global_rotation > PI/2 - PI and $GunPoint.global_rotation < PI/2:
			$Sprite2D.flip_h = false
		else: 
			$Sprite2D.flip_h = true

	else:
		$Line2D.visible = false
	
		

	if not cutscene_mode:
		input_axis = Input.get_axis("ui_left", "ui_right")
	else:
		input_axis = 0
	if not was_last_on_floor and is_on_floor():
		$Land.play(0)

	

	#logic to handle jumps
	
	if !Input.is_action_pressed("jump"):
		if is_on_floor():
			allowed_to_jump = true
	if jump_frame_counter > max_jump_held_frames:
		allowed_to_jump = false

	if !is_on_floor():

		if sign(velocity.y) == -1:

			$AnimationPlayer.play("jump_up")
		elif sign(velocity.y) == 1:
			$AnimationPlayer.play("fall")



func _physics_process(delta):
	if velocity.x * sign(input_axis) < max_floor_speed:
		velocity += Vector2(input_axis * accelerate, 0)


	if is_on_floor():
		if abs(velocity.x) > max_floor_speed:
			velocity.x = lerpf(velocity.x, 
				max_floor_speed * sign(velocity.x), 
				1 / max_floor_speed * (accelerate)
			)
		if input_axis == 0:
			velocity.x = lerpf(velocity.x, 0, 1 / max_floor_speed * accelerate)
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("walk")
		
	else:
		if abs(velocity.x) > max_air_speed:
			velocity.x = lerpf(velocity.x, 
				max_air_speed * sign(velocity.x), 
				1 / max_floor_speed * 10
			)
	velocity.y += gravity * delta

	if allowed_to_jump and Input.is_action_pressed("jump"):
		if jump_frame_counter == 0:
			if is_on_floor() && Input.is_action_just_pressed("jump"):
				velocity.y -= jump_velocity
				$JumpSound.play(0)
				jump_frame_counter += 1
		else:
			velocity.y -= jump_hold_velocity
			jump_frame_counter += 1
	else:
		jump_frame_counter = 0
	

	move_and_slide()
	was_last_on_floor = is_on_floor()



func on_dash_timer_timeout():
	dashes_left = 1

func start_cutscene():
	cutscene_mode = true

func die():
	if	get_tree().get_first_node_in_group("stopwatch").current_time > 1:
		can_die = false
		print("ded")
		$Timer.start(1.5)
		died.emit()

func on_death_timer_timeout():
	if can_die == false:
		can_die = true
