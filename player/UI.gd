extends Control

@onready var player: Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	$Mail1.visible = true if player.mail_remaining >= 1 else false
	$Mail2.visible = true if player.mail_remaining >= 2 else false
	$Mail3.visible = true if player.mail_remaining >= 3 else false
	$Mail4.visible = true if player.mail_remaining >= 4 else false
	$Mail5.visible = true if player.mail_remaining >= 5 else false
