extends Node2D
class_name GameManager

static var instance: GameManager = self

var is_input_mode: bool = false

var current_inspection: GameObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func analyze(command: String) -> String:
	var command_composition: PackedStringArray = command.replace("\n","").split(" ")
	match command_composition[0]:
		"start":
			return "Started a new game."
		_:
			return "Failed to read command."
	return "Failed to read command."

func start_new_game() -> void:
	pass

func set_inspector(target: GameObject) -> void:
	current_inspection = target
