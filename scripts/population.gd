extends Node2D
class_name Population

static var instance: Population = self

var total_population: int = 0
var families: Array[Family];
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self

func generate_first_name(gender: String) -> String:
	match gender:
		"male":
			return male_names[randi_range(0,male_names.size()-1)]
		"female":
			return female_names[randi_range(0,female_names.size()-1)]
		_:
			return "Jesus"

func generate_last_name() -> String:
	return last_names[randi_range(0,last_names.size()-1)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tick_every_citizen() -> void:
	for citizen in get_children():
		citizen.tick()

func create_new_family() -> Family:
	var temp_family = Family.new(generate_last_name())
	families.append(temp_family)
	return temp_family

func spawn_citizen(_family: Family, gender: String ="random", birth_tick: int =GameManager.instance.current_tick,pos_x: float=0, pos_y: float=0) -> Citizen:
	var temp = Citizen.new(_family, gender, birth_tick)
	temp.position = Vector2(pos_x + randi_range(-10,+10), pos_y + randi_range(-10, +10))
	_family.family_members.append(temp)
	add_child(temp)
	total_population+=1
	return temp
