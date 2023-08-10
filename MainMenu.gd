extends Control

class_name MainMenu

var center_of_screen = Vector2.ZERO
var rect = get_viewport_rect()

@onready var player = preload("res://player/Player.tscn")
var unpacked_player: Player
var level_index = 0
@onready var level_one: PackedScene = preload("res://levels/Level1.tscn")
@onready var menu: FailScreen = get_tree().get_first_node_in_group("allmenu")
@export var level_select: Control
var next_packed_level: PackedScene
@onready var current_packed_level: PackedScene = level_one
var next_level: Level
var current_level: Level

signal level_starting(level:int)
signal level_ending

var all_levels_list = DirAccess.get_files_at("res://levels")

# 400, 472

# Called when the node enters the scene tree for the first time.
func _ready():
	center_of_screen = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size()/2)
	print(center_of_screen)
	menu.main_menu.connect(on_main_menu)
	menu.retrying.connect(on_retry)
	$start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# var dist_to_mouse = ((get_global_mouse_position() - Vector2(center_of_screen))* -1)
	#print(get_global_mouse_position())
	#get = lerp(global_position, dist_to_mouse, 0.5)
	if Input.is_action_pressed("pause") and not visible:
		menu.pause()
	

func _on_start_pressed():
	if get_tree().paused:
		get_tree().paused = false
	if unpacked_player == null:
		unpacked_player = player.instantiate()
		get_tree().root.get_child(0).add_child(unpacked_player)
	if current_level != null and not current_level.is_queued_for_deletion():
		current_level.queue_free()
	unpacked_player.show()
	current_packed_level = load("res://levels/" + all_levels_list[0])
	level_index = 0
	current_level = current_packed_level.instantiate()
	get_tree().root.get_child(0).add_child(current_level)
	current_level.level_completed.connect(on_level_completed)
	current_level.level_failed.connect(on_level_failed)
	unpacked_player.position = Vector2(80, 500)
	level_starting.emit(0)
	unpacked_player.cam.enabled = true
	$start.disabled = true
	$start.button_pressed = false
	$quit.disabled = true
	$quit.button_pressed = false
	hide()

func on_level_completed():
	hide()

	if all_levels_list.size() - 1 < level_index + 1:
		level_ending.emit()
		menu.final_level_done()
		return
	if menu:
		level_ending.emit()
		menu.level_done()
		level_index += 1
		await menu.next_level

	print("complete recieved")
	current_packed_level = load("res://levels/" + all_levels_list[level_index])
	current_level.queue_free()
	next_level = current_packed_level.instantiate()
	current_level = next_level
	current_level.level_failed.connect(on_level_failed)
	current_level.level_completed.connect(on_level_completed)

	get_tree().root.get_child(0).add_child(current_level)
	unpacked_player.cam.enabled = true
	unpacked_player.show()
	unpacked_player.position = Vector2(40, 500)
	level_starting.emit(level_index)
	
func on_level_failed(_failure_message: String):
	print("recieved fail")
	if menu:
		menu.fail()
	

func _on_quit_pressed():
	get_tree().quit()

func on_retry():
	print("retry recieved")
	unpacked_player.collider.disabled = true
	unpacked_player.position = Vector2(40, 500)
	next_level = current_packed_level.instantiate()
	current_level.queue_free()
	current_level = next_level
	current_level.level_failed.connect(on_level_failed)
	current_level.level_completed.connect(on_level_completed)
	unpacked_player.cam.enabled = true
	get_tree().root.get_child(0).add_child(next_level)
	unpacked_player.collider.disabled = false

func on_main_menu():
	visible = true
	print("why are you here")
	unpacked_player.hide()
	$start.disabled = false
	$start.grab_focus()
	$quit.disabled = false
	unpacked_player.cam.enabled = false
	if current_level != null:
		current_level.queue_free()


func _on_button_pressed():
	level_select.show()
	level_select.get_node("Button").grab_focus()

func on_level_selected(idx: int):
	print("level select recieved")
	if get_tree().paused:
		get_tree().paused = false
	if unpacked_player == null:
		unpacked_player = player.instantiate()
		get_tree().root.get_child(0).add_child(unpacked_player)
	if current_level != null and not current_level.is_queued_for_deletion():
		current_level.queue_free()
	unpacked_player.show()
	print(all_levels_list[idx])
	current_packed_level = load("res://levels/" + all_levels_list[idx])
	level_index = idx
	current_level = current_packed_level.instantiate()
	get_tree().root.get_child(0).add_child(current_level)
	current_level.level_completed.connect(on_level_completed)
	current_level.level_failed.connect(on_level_failed)
	unpacked_player.position = Vector2(80, 500)
	level_starting.emit(idx)
	unpacked_player.cam.enabled = true
	$start.disabled = true
	$start.button_pressed = false
	$quit.disabled = true
	$quit.button_pressed = false
	hide()

