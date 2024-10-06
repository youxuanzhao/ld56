extends GameObject

class_name Citizen

@onready var click_detection: Area2D = $ClickDetection
@onready var interact_area: Area2D = $InteractArea

var on_hover: bool = false

var first_name: String
var family_name : String
var family: Family
var age: int
var birthdate: int
var gender: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _init(family_name: String, ) -> void:
	pass


func _on_click_detection_mouse_entered() -> void:
	on_hover = true


func _on_click_detection_mouse_exited() -> void:
	on_hover = false
