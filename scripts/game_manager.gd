extends Node2D
class_name GameManager

static var instance: GameManager

@onready var camera: Camera2D = $Camera2D
@onready var time_display: Label = $CanvasLayer/TimeDisplay
@onready var title_display: Label = $CanvasLayer/Title
@onready var tick_timer: Timer = $Timer

var is_input_mode: bool = false
var is_paused: bool = false
var current_civilization_name: String = ""
var year_length: int = 365
var current_tick: int = 0
var seconds_per_tick: float = 1
var is_game_running: bool = false
var border_line: Line2D
var last_speed: float = 1

var area_width: int = 200
var area_height: int = 200

const MISSING_PARAM: String = "Missing parameter(s)."
const INCORRECT_PARAM: String = "Incorrect parameter."
const FAILED_TO_READ: String = "Failed to read command."
const RESET_CAM: String = "Reset camera position."

const HELP: Dictionary = {
	"start": "`start <name: String>`: Start a new game with a unique name.",
	"set_game_area": "`set_game_area <width: int> <height: int>`: Set the world's dimensions. Preferred 200*200.",
	"set_game_speed": "`set_game_speed <speed: int>`: Set how many ticks per second. Any value that is smaller than 0 will pause the game. Preferred speed = 500.",
	"set_console_opacity": "`set_console_opacity <value: float>`: Set the console opacity. Value should be between 0 and 1.",
	"pause": "`pause`: Pause the game.",
	"resume": "`resume`: Resume the game, alias to `unpause`.",
	"unpause": "`unpause`: Unpause the game, alias to `resume`.",
	"thanos": "`thanos`: Randomly removing lives with a chance of 50%. Dramatically reduces lagging.",
	"restart": "`restart`: Restart the game.",
	"reset_camera": "`reset_camera`: Reset camera position.",
	"help": "`help <command: String>`: Get detailed information about a command. If no command is specified, it will return a list of all commands.",
	"?": "`? <command: String>`: Alias to `help`.",
}

var time_count: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("resume") and !is_input_mode:
		match is_paused:
			true:
				set_game_speed(str(last_speed))
			false:
				last_speed = 1/seconds_per_tick
				set_game_speed("0")

# Move this part to a new file, find a wiser way
func analyze(command: String) -> String:
	var command_composition: PackedStringArray = command.replace("\n","").split(" ")
	match command_composition[0]:
		"restart":
			get_tree().reload_current_scene()
			return "Restarted the game."
		"thanos":
			return kill_half_population()
		"set_game_area":
			if command_composition.size() < 3:
				return MISSING_PARAM
			else:
				return set_game_area(command_composition[1], command_composition[2])
		"unpause","resume":
			return set_game_speed(str(last_speed))
		"pause":
			last_speed = 1/seconds_per_tick
			return set_game_speed("0")
		"set_game_speed":
			if command_composition.size() < 2:
				return MISSING_PARAM
			else:
				return set_game_speed(command_composition[1])
		"reset_camera":
			camera.position = Vector2.ZERO
			return RESET_CAM
		"start":
			if command_composition.size() < 2:
				return MISSING_PARAM
			else:
				return start_new_game(command_composition[1])
		"set_console_opacity":
			if command_composition.size() < 2:
				return MISSING_PARAM
			else:
				if command_composition[1].is_valid_float():
					var value: float = float(command_composition[1])
					if value < 0 or value > 1:
						return INCORRECT_PARAM
					else:
						set_console_opacity(value)
						return "Set console opacity to " + str(value) + "."
				else:
					return INCORRECT_PARAM
		"help","?":
			if command_composition.size() > 2:
				return INCORRECT_PARAM
			elif command_composition.size() == 1:
				var help_text: String = "Available commands:\n"
				for value in HELP.values():
					help_text += value + "\n"
				return help_text
			else:
				if HELP.has(command_composition[1]):
					return HELP[command_composition[1]]
				else:
					return INCORRECT_PARAM
		"set_background_color":
			if command_composition.size() < 2:
				return MISSING_PARAM
			elif command_composition.size() == 2:
				if Color.html_is_valid(command_composition[1]):
					return set_background_color_string(command_composition[1])
				else:
					return INCORRECT_PARAM
			elif command_composition.size() == 4:
				if command_composition[1].is_valid_float() and command_composition[2].is_valid_float() and command_composition[3].is_valid_float():
					return set_background_color_rgb(float(command_composition[1]), float(command_composition[2]), float(command_composition[3]))
				else:
					return INCORRECT_PARAM
			else:
				return INCORRECT_PARAM
		_:
			return FAILED_TO_READ

func set_game_area(width: String, height: String) -> String:
	if !width.is_valid_int() or !height.is_valid_int():
		return INCORRECT_PARAM
	else:
		area_width = int(width)
		area_height = int(height)
		if border_line != null:
			border_line.queue_free()
		border_line = Line2D.new()
		var points: PackedVector2Array = [Vector2(0-area_width/2,0-area_height/2), Vector2(0+area_width/2,0-area_height/2), Vector2(0+area_width/2,0+area_height/2), Vector2(0-area_width/2,0+area_height/2), Vector2(0-area_width/2,0-area_height/2)]
		border_line.points = points
		border_line.width = 1
		add_child(border_line)
		return "Set game area to " + width + "x" + height + "."
		

# We should allow pre-configuration of the game
func start_new_game(argument: String) -> String:
	current_civilization_name = argument
	current_tick = 0
	seconds_per_tick = 1
	is_game_running = true
	update_title()
	update_time_display()
	tick_timer.start(seconds_per_tick)
	var temp_family = Population.instance.create_new_family()
	Population.instance.spawn_citizen(temp_family,"male",0)
	Population.instance.spawn_citizen(temp_family,"male",0)
	Population.instance.spawn_citizen(temp_family,"female",0)
	Population.instance.spawn_citizen(temp_family,"female",0)
	var another_family = Population.instance.create_new_family()
	Population.instance.spawn_citizen(another_family,"male",0)
	Population.instance.spawn_citizen(another_family,"male",0)
	Population.instance.spawn_citizen(another_family,"female",0)
	Population.instance.spawn_citizen(another_family,"female",0)
	
	return "Started a new civilization of " + argument + "."

func set_game_speed(argument: String) -> String:
	if argument.is_valid_float():
		if float(argument) <= 0:
			is_paused = true
			tick_timer.paused = true
			return "You paused the game."
		else:
			tick_timer.paused = false
			is_paused = false
			seconds_per_tick = 1/float(argument)
		return "Set game speed to " + argument + "."
	else:
		return INCORRECT_PARAM

func convert_tick_to_date(tick: int) -> String:
	var year: int = 0
	var day: int = 0
	year = tick / year_length
	day = tick % year_length
	return "Y" + str(year) + ", D" + str(day)

func update_title() -> void:
	title_display.text = str(current_civilization_name," (",Population.instance.total_population,")")

func update_time_display() -> void:
	time_display.text = convert_tick_to_date(current_tick)

func kill_half_population() -> String:
	var count = 0
	for citizen in Population.instance.get_children():
		if citizen.is_alive and randi()%2 == 1:
			count+=1
			citizen.die()
	return "Great! You just removed "+str(count)+" lives!"

func _on_timer_timeout() -> void:
	current_tick += 1
	Population.instance.tick_every_citizen()
	Inspector.instance.update_inspector_display()
	update_title()
	update_time_display()
	tick_timer.start(seconds_per_tick)

func set_console_opacity(value: float) -> void:
	var console = Console.instance
	console.console_log_display.modulate.a = value

func set_background_color_string(color: String) -> String:
	var color_value: Color = Color(color)
	if color_value == null:
		return INCORRECT_PARAM
	RenderingServer.set_default_clear_color(color_value)
	return "Set background color to " + color + "."

func set_background_color_rgb(r: float, g: float, b:float) -> String:
	var color_value: Color = Color(r, g, b)
	if color_value == null:
		return INCORRECT_PARAM
	RenderingServer.set_default_clear_color(color_value)
	return "Set background color to RGB(" + str(r) + ", " + str(g) + ", " + str(b) + ")."
