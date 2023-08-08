extends CanvasLayer

class_name FailScreen

signal retrying
signal main_menu
signal resuming
signal pausing
signal next_level

var paused = false

var is_pause_menu = false
var is_fail_menu = false
var is_next_menu = false
var is_last_menu = false
var message: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Button.disabled = false
	$Control/Button2.disabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Control/Label/Message.text != message:
		$Control/Label/Message.text = message
	
	if is_pause_menu:
		$Control/Label/Message.text = ""
		$Control/Label.text = "Paused"
		$Control/Button2.text = "Restart"
	elif is_fail_menu:
		$Control/Label/Message.text = ""
		$Control/Label.text = "You Failed"
		$Control/Button2.text = "Retry"
	elif is_next_menu:
		$Control/Label.text = "Level Completed!"
		$Control/Button2.text = "Next"
	elif is_last_menu:
		$Control/Label.text = "Thanks For Playing!"
		$Control/Button2.text = "Quit"

func level_done():
	$Control/AnimationPlayer.play("swoop_in")
	$Control/Button2.grab_focus()
	get_tree().paused = true
	$Control/Button2.button_pressed = false
	$Control/Button.button_pressed = false
	is_next_menu = true
	is_pause_menu = false
	is_fail_menu = false
	$Control.visible = true
	$Control/Button.disabled = false
	$Control/Button2.disabled = false

func final_level_done():
	$Control/AnimationPlayer.play("swoop_in")
	$Control/Button2.grab_focus()
	get_tree().paused = true
	$Control/Button2.button_pressed = false
	$Control/Button.button_pressed = false
	is_next_menu = false
	is_pause_menu = false
	is_fail_menu = false
	is_last_menu = true
	$Control.visible = true
	$Control/Button.disabled = false
	$Control/Button2.disabled = false

func fail():
	get_tree().paused = true
	$Control/Button2.button_pressed = false
	$Control/Button.button_pressed = false
	is_next_menu = false
	is_pause_menu = false
	is_fail_menu = true
	$Control.visible = true
	$Control/AnimationPlayer.play("swoop_in")
	$Control/Button2.grab_focus()
	$Control/Button.disabled = false
	$Control/Button2.disabled = false

func pause():
	if not paused:

		pausing.emit()
		$Control/Button2.button_pressed = false
		$Control/Button.button_pressed = false
		get_tree().paused = true
		is_next_menu = false
		is_pause_menu = true
		is_fail_menu = false
		$Control.visible = true
		$Control/AnimationPlayer.play("swoop_in")
		$Control/Button2.grab_focus()
		await $Control/AnimationPlayer.animation_finished
		paused = true
	else:
		resuming.emit()
		$Control/AnimationPlayer.play_backwards("swoop_in")
		await $Control/AnimationPlayer.animation_finished
		get_tree().paused = false
		$Control.visible = false
		paused = false


	
	$Control/Button.disabled = false
	$Control/Button2.disabled = false

func _on_button_pressed():
	print("button pressed")
	$Control/AnimationPlayer.play_backwards("swoop_in")
	$Control/AnimationPlayer.animation_finished.connect(on_anim_finsihed_menu)
	$Control/Button.disabled = true
	$Control/Button2.disabled = true



func _on_button_2_pressed():
	print("button_2 pressed")
	$Control/AnimationPlayer.play_backwards("swoop_in")
	$Control/AnimationPlayer.animation_finished.connect(on_anim_finsihed_retry)
	$Control/Button.disabled = true
	$Control/Button2.disabled = true

func on_anim_finsihed_menu(_anim_name):
		$Control/AnimationPlayer.disconnect("animation_finished", on_anim_finsihed_menu)
		$Control.visible = false
		get_tree().paused = true
		main_menu.emit()
		print("main_menu")

func on_anim_finsihed_retry(_anim_name):
		$Control.visible = false
		get_tree().paused = false
		if is_fail_menu or is_pause_menu:

			retrying.emit()
			print("retrying ...")
			$Control/AnimationPlayer.disconnect("animation_finished", on_anim_finsihed_retry)
		elif is_next_menu:
			print("next level")
			$Control/AnimationPlayer.disconnect("animation_finished", on_anim_finsihed_retry)
			next_level.emit()
		elif is_last_menu:
			get_tree().quit()

