extends Control
class_name Console

@onready var console_input: TextEdit = $ConsoleInput
@onready var console_log_display: Label = $ConsoleLog

static var instance: Console = self

var on_hover: bool = false

var msg: PackedStringArray = PackedStringArray()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	console_input.editable = false
	update_console_log_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and on_hover:
		console_input.editable = true	
	
	if Input.is_action_just_pressed("command_enter") and GameManager.instance.is_input_mode:
		msg.append(GameManager.instance.analyze(console_input.text))
		if msg.size() > 5:
			msg = msg.slice(1)
		console_input.clear()
		console_input.editable = false
		GameManager.instance.is_input_mode = false
		update_console_log_display()
	
	if Input.is_action_just_pressed("command_cancel"):
		console_input.editable = false
		GameManager.instance.is_input_mode = false


func update_console_log_display() -> void:
	console_log_display.text = "\n".join(msg)


func _on_console_input_text_changed() -> void:
	GameManager.instance.is_input_mode = true


func _on_console_input_mouse_entered() -> void:
	on_hover = true


func _on_console_input_mouse_exited() -> void:
	on_hover = false
