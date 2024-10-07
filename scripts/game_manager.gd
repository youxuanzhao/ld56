extends Node2D
class_name GameManager

static var instance: GameManager = self

var is_input_mode: bool = false
var current_civilization_name: String = ""
var year_length: int = 365
var current_tick: int = 0
var tick_per_second: int = 1

var female_names: Array[String] = [
	"Abigail",
	"Alexandra",
	"Alison",
	"Amanda",
	"Amelia",
	"Amy",
	"Andrea",
	"Angela",
	"Anna",
	"Anne",
	"Audrey",
	"Ava",
	"Bella",
	"Bernadette",
	"Carol",
	"Caroline",
	"Carolyn",
	"Chloe",
	"Claire",
	"Deirdre",
	"Diana",
	"Diane",
	"Donna",
	"Dorothy",
	"Elizabeth",
	"Ella",
	"Emily",
	"Emma",
	"Faith",
	"Felicity",
	"Fiona",
	"Gabrielle",
	"Grace",
	"Hannah",
	"Heather",
	"Irene",
	"Jan",
	"Jane",
	"Jasmine",
	"Jennifer",
	"Jessica",
	"Joan",
	"Joanne",
	"Julia",
	"Karen",
	"Katherine",
	"Kimberly",
	"Kylie",
	"Lauren",
	"Leah",
	"Lillian",
	"Lily",
	"Lisa",
	"Madeleine",
	"Maria",
	"Mary",
	"Megan",
	"Melanie",
	"Michelle",
	"Molly",
	"Natalie",
	"Nicola",
	"Olivia",
	"Penelope",
	"Pippa",
	"Rachel",
	"Rebecca",
	"Rose",
	"Ruth",
	"Sally",
	"Samantha",
	"Sarah",
	"Sonia",
	"Sophie",
	"Stephanie",
	"Sue",
	"Theresa",
	"Tracey",
	"Una",
	"Vanessa",
	"Victoria",
	"Virginia",
	"Wanda",
	"Wendy",
	"Yvonne",
	"Zoe"
]

var male_names: Array[String] = [
	"Adam",
	"Adrian",
	"Alan",
	"Alexander",
	"Andrew",
	"Anthony",
	"Austin",
	"Benjamin",
	"Blake",
	"Boris",
	"Brandon",
	"Brian",
	"Cameron",
	"Carl",
	"Charles",
	"Christian",
	"Christopher",
	"Colin",
	"Connor",
	"Dan",
	"David",
	"Dominic",
	"Dylan",
	"Edward",
	"Eric",
	"Evan",
	"Frank",
	"Gavin",
	"Gordon",
	"Harry",
	"Ian",
	"Isaac",
	"Jack",
	"Jacob",
	"Jake",
	"James",
	"Jason",
	"Joe",
	"John",
	"Jonathan",
	"Joseph",
	"Joshua",
	"Julian",
	"Justin",
	"Keith",
	"Kevin",
	"Leonard",
	"Liam",
	"Lucas",
	"Luke",
	"Matt",
	"Max",
	"Michael",
	"Nathan",
	"Neil",
	"Nicholas",
	"Oliver",
	"Owen",
	"Paul",
	"Peter",
	"Phil",
	"Piers",
	"Richard",
	"Robert",
	"Ryan",
	"Sam",
	"Sean",
	"Sebastian",
	"Simon",
	"Stephen",
	"Steven",
	"Stewart",
	"Thomas",
	"Tim",
	"Trevor",
	"Victor",
	"Warren",
	"William"
]
var last_names: Array[String] = [
	"Smith",
	"Jones",
	"Taylor",
	"Brown",
	"Williams",
	"Wilson",
	"Johnson",
	"Davies"
]

var current_inspection: GameObject

const MISSING_PARAM: String = "Missing parameter(s)."
const FAILED_TO_READ: String = "Failed to read command."


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
			if command_composition.size() < 2:
				return MISSING_PARAM
			else:
				return start_new_game(command_composition[1])
		_:
			return FAILED_TO_READ

func start_new_game(argument: String) -> String:
	current_civilization_name = argument
	return "Started a new civilization of" + argument + "."

func set_inspector(target: GameObject) -> void:
	current_inspection = target

func generate_first_name(gender: String) -> String:
	match gender:
		"male":
			return male_names[randi_range(0,male_names.size())]
		"female":
			return female_names[randi_range(0,female_names.size())]
		_:
			return "Jesus"

func convert_tick_to_date(tick: int) -> String:
	var year: int = 0
	var day: int = 0
	year = tick / year_length
	day = tick % year_length
	return "Year " + str(year) + " Day " + str(day)

func generate_last_name() -> String:
	return last_names[randi_range(0,last_names.size())]
