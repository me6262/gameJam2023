extends Button

@export var on_texture: Texture2D
@export var off_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_toggled(button_pressed_bro:bool):
	icon = off_texture if button_pressed_bro else on_texture
