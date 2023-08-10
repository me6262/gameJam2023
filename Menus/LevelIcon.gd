@tool
extends Button

signal level_selected(idx: int)

var level_string: String = "stuff"
var level_number: int

var level_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("i'm here")
	text = "Stuffdjsfsdjkh"


# Called every frame. 'delta' is the elapsed time since the previous frame.

func change_data(level_num: String, time: float):
	text = level_num
	$Label.text = str(time)
	level_number = int(level_num) - 1


func _on_pressed():
	print("level button pressed internally")
	level_selected.emit(level_number)
	

