extends Node2D
class_name Population

static var instance: Population = self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_citizen() -> Citizen:
	pass
