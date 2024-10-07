class_name Dead
extends Behavior

func _init(date: String):
	name = "dead"
	max_progress = 1000
	current_progress = 0
	progress_per_tick = 0
	display_name = "This citizen died on " + date
