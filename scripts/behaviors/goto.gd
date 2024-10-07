class_name GoTo
extends Behavior

var destination: Vector2
var subject: Node2D

func _init(_subject: Node2D, _destination: Vector2, _speed: float):
	name = "goto"
	display_name = "Going to (" + str(_destination.x) + ", " + str(_destination.y) + ")"
	max_progress = _subject.position.distance_to(_destination)
	current_progress = 0
	progress_per_tick = _speed
	subject = _subject
	destination = _destination

func _tick() -> bool:
	subject.position += subject.position.direction_to(destination) * progress_per_tick
	return super._tick()
	
