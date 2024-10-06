class_name Sex 
extends Behavior

var father: Citizen
var mother: Citizen


func _init(_father: Citizen, _mother: Citizen):
    name = "sex"
    display_name = "Having sex"
    max_progress = 100
    current_progress = 0
    progress_per_second = 10
    father = _father
    mother = _mother