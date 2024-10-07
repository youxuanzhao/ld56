class_name Behavior

var name: String
var display_name: String
var max_progress: float
var current_progress: float
var progress_per_tick: float
func _behavior_completed():
	pass
func _init():
	pass

func _end():
	pass

func _tick() -> bool:
	current_progress += progress_per_tick
	if current_progress >= max_progress:
		current_progress = max_progress
		return true
	else:
		return false
	
