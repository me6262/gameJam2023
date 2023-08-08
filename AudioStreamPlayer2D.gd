extends AudioStreamPlayer2D


var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	else:
		global_position = player.global_position
	if not playing:
		play(0)
