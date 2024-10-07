extends Control
class_name Inspector

static var instance: Inspector = self

var current_inspection: GameObject

@onready var inspector_display: Label = $InspectorDisplay
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	update_inspector_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_inspector_display():
	if current_inspection == null:
		visible = false
		inspector_display.text = ""
		return
	
	if current_inspection is Citizen:
		visible = true
		inspector_display.text = "Citizen\n\n"+"Name: "+current_inspection.first_name+" "+current_inspection.family_name+"\nGender: "+current_inspection.gender+"\nAge: "+str(current_inspection.age)+"\nBirthdate: "+current_inspection.birth_date+"\n"
		var suffix = ""
		match GameManager.instance.current_tick%3:
			0:
				suffix = "."
			1:
				suffix = ".."
			2:
				suffix = "..."
		inspector_display.text = inspector_display.text + "\n" + current_inspection.current_behavior.display_name + suffix + "\n" + str(current_inspection.current_behavior.current_progress).pad_decimals(2) + "/" + str(current_inspection.current_behavior.max_progress).pad_decimals(2)
