class_name GivingBirth
extends Behavior

var mother: Citizen
var father: Citizen

func _init(_father: Citizen, _mother: Citizen):
	name = "giving_birth"
	max_progress = 270
	current_progress = 0
	progress_per_tick = 1
	father = _father
	mother = _mother
	display_name = "Giving birth"

func _end():
	if father != null and mother != null:
		Population.instance.spawn_citizen(father.family, "random", GameManager.instance.current_tick, mother.position.x, mother.position.y)
	mother.is_pregnant = false
