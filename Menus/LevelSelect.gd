@tool
extends Control

signal level_selected(idx: int)

var first_run = true
var level_folder = "res://levels"
var level_icons: PackedScene = preload("res://Menus/LevelIcon.tscn")
@onready var dir = DirAccess.get_files_at(level_folder)
@onready var folder_size = dir.size()
@onready var current_layer:HBoxContainer
var times = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print("bruh")
	script_changed.connect(on_script_changed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if DirAccess.get_files_at(level_folder).size() == dir.size() and not first_run:
		return
	var i = 0
	if times.size() <= 0:
		times = FileAccess.open("user://leaderboard.dat", FileAccess.READ).get_var(true)
	
	dir = DirAccess.get_files_at(level_folder)
	current_layer = HBoxContainer.new()
	current_layer.add_spacer(true)
	$VBoxContainer.add_child(current_layer)
	for file in dir:
		print(file)
		var level_icon = level_icons.instantiate()
		current_layer.add_child(level_icon)
		current_layer.add_spacer(false)
		level_icon.change_data("%d" % (i + 1), times[i] if times.size() > i else 0)
		level_icon.level_selected.connect(on_selected)
		# if (i + 1) % 8 == 0: 
		# 	pass
		if (i + 1) % 4 == 0:
			print("new layer")
			current_layer = HBoxContainer.new()
			current_layer.add_spacer(true)
			$VBoxContainer.add_spacer(false)
			$VBoxContainer.add_child(current_layer)
		first_run = false
		i += 1
	$VBoxContainer.add_spacer(true)	

func on_script_changed():
	for child in $VBoxContainer.get_children():
		child.queue_free()
	first_run = false


func _on_button_pressed():
	hide()
	
func on_selected(idx: int):
	print("level button pressed")
	hide()
	level_selected.emit(idx)
	


func _on_stopwatch_new_best(time: float, level: int):
	for child in $VBoxContainer.get_children():
		child.queue_free()
	first_run = false
	times[level] = time

