@tool
extends Button

class_name LevelButton

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text_engine("s")


func set_text_engine(s: String):
	set_text(s)

