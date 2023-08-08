extends Node2D

var can_kill = false

# Called when the node enters the scene tree for the first time.

func _ready():
	get_tree().create_timer(1).timeout.connect(func(): can_kill = true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_body_entered(body: Node2D): 
	if body is Player and can_kill:
		print("killing player")
		body.die()
