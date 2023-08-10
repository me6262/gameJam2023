extends Level

var settings_done = false

func _ready():
	level_started.emit()

func _process(delta):
	if not settings_done:
		get_tree().get_first_node_in_group("Mailbox").mail_recieved.connect(on_mail_recieved)
		get_tree().get_first_node_in_group("Mailbox").mail_required = mail_required
		get_tree().get_first_node_in_group("Player").died.connect(on_died)
		player.mail_remaining = starting_mail
		settings_done = true

func on_mail_recieved():

	print("jjdfhskjfhjskdhfjksdhfsjkdhfksjdhfsdjhfskjdfhs")
	level_completed.emit()
	
func on_died():
	print("Recieved died signal")
	level_failed.emit("You Died")
