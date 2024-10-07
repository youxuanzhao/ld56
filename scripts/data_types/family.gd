class_name Family

var family_name: String
var family_members: Array[Citizen]
var family_color: Color

func _init(_family_name: String) -> void:
	family_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	family_name = _family_name
