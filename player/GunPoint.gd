extends Node2D

var gun_list: Array[Gun]
@export var player: Player

var gun_rotation
var last_mouse_pos
var gun_index = 0
var equipped_gun: Gun
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Gun:
			gun_list.append(child)
		
	equip_gun(gun_list[0])	

func _input(event):
	if event.is_action_pressed("next_slot"):
		if gun_index < gun_list.size() - 1:
			gun_index += 1
		else:
			gun_index = 0
		equip_gun(gun_list[gun_index])
	elif event.is_action_pressed("prev_slot"):
		if gun_index > 0:
			gun_index -= 1
		else:
			gun_index = gun_list.size() - 1
		equip_gun(gun_list[gun_index])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("aim"):
		gun_rotation = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		if gun_rotation == Vector2.ZERO:
			if last_mouse_pos != get_global_mouse_position():
				look_at(get_global_mouse_position())
			else:
				#TODO: this
				pass
		else:
			rotation = lerp_angle(rotation, gun_rotation.angle(), 0.5)
	else:
		if player.input_axis > 0:
			global_rotation = -3.5 - PI
		elif player.input_axis < 0:
			global_rotation = 3.5


	last_mouse_pos = get_global_mouse_position()
	if Input.is_action_pressed("attack"):
		equipped_gun.shoot()

func equip_gun(gun: Gun):
	if equipped_gun != null:
		equipped_gun.switch_out()
	await gun.switch_in()
	
	equipped_gun = gun


