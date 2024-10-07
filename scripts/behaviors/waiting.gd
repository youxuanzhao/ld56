class_name Waiting
extends Behavior

func _init(wait_ticks: int):
	name = "waiting"
	display_name = "Waiting"
	max_progress = wait_ticks
	current_progress = 0
	progress_per_tick = 1
