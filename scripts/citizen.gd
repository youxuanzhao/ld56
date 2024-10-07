extends GameObject

class_name Citizen

@onready var click_detection: Area2D = $ClickDetection
@onready var interact_area: Area2D = $InteractArea

var on_hover: bool = false

var first_name: String
var family_name : String
var family: Family
var age: int
var birth_tick: int
var birth_date: String
var gender: String

var father: Citizen
var mother: Citizen
var spouse: Citizen
var children: Array[Citizen]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _init(_family: Family) -> void:
	family = _family
	family_name = family.family_name
	match randi() % 2:
		0:
			gender = "male"
		1: 
			gender = "female"
	first_name = GameManager.instance.generate_first_name(gender)
	age = 0
	birth_tick = GameManager.instance.current_tick
	birth_date = GameManager.instance.convert_tick_to_date(birth_tick)

func tick() -> void:
	make_decision()
	age = (GameManager.instance.current_tick - birth_tick) / GameManager.instance.year_length
	if age < 0:
		age = 0

func make_decision() -> void:
	pass


func _on_click_detection_mouse_entered() -> void:
	on_hover = true


func _on_click_detection_mouse_exited() -> void:
	on_hover = false
