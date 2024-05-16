extends CanvasLayer

@export var menu: FailScreen
@export var main: MainMenu

signal timing_start
signal timing_end(time:int)
signal new_best(time: float, level:int)

var current_level: int

var file: FileAccess
var times: Array = []

var level_started: float
var current_time: float
var counting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_started = Time.get_unix_time_from_system()
	main.level_starting.connect(on_level_start)
	main.level_ending.connect(on_level_finished)
	menu.retrying.connect(on_level_restart)
	if OS.get_name() != "Web" and false:

		file = FileAccess.open("user://leaderboard.dat", FileAccess.READ)
		times = file.get_var(true) 
		print(times)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		current_time = Time.get_unix_time_from_system() - level_started
		$Control/Label.text = "%5.2f" % current_time 
	else:
		hide()

func on_level_finished():
	menu.message = $Control/Label.text
	hide()
	counting = false
	timing_end.emit()
	if times.size() >= current_level + 1:
		if times[current_level] > float($Control/Label.text):
			new_best.emit(float($Control/Label.text), current_level)
			print("better time")
			times[current_level] = float($Control/Label.text)
	else:
		print("array too small")
		while times.size() < current_level - 1:
			times.append(0)
		times.append(float($Control/Label.text))

	

func on_level_start(num: int):
	show()
	print("stopwatch level started")
	level_started = Time.get_unix_time_from_system()
	counting = true
	current_level = num

func on_level_restart():
	show()
	level_started = Time.get_unix_time_from_system()
	counting = true

	
func _exit_tree():
	if OS.get_name() != "Web":

		var writer = FileAccess.open("user://leaderboard.dat", FileAccess.WRITE)
		writer.store_var(times)
