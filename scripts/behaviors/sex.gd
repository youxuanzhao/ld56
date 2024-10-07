class_name Sex 
extends Behavior

var father: Citizen
var mother: Citizen
var possibility: float


func _init(_father: Citizen, _mother: Citizen):
	name = "sex"
	max_progress = 10
	current_progress = 0
	progress_per_tick = 2
	father = _father
	mother = _mother
	possibility = ((45-father.age) + (45-mother.age))*1.5
	display_name = "Having sex ("+str(possibility)+"%)"

func _end():
	if mother != null and father != null:
		if randi_range(0,100) <= possibility:
			mother.is_pregnant = true
			mother.current_behavior = GivingBirth.new(father, mother)
