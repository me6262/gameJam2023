@tool
extends Button

var level_string: String = "stuff"
var level_scene_string: String
var level_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("i'm here")
	text = "Stuffdjsfsdjkh"


# Called every frame. 'delta' is the elapsed time since the previous frame.

func change_data(level_num: String, time: float, scene_string:String):
	text = level_num
	$Label.text = str(time)
	level_scene_string = scene_string
