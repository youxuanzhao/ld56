extends Camera2D

@export var distance_each_input: float = 10


var x_input = 0
var y_input = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("camera_high"):
		zoom.x -= 1
		zoom.y -= 1
	if Input.is_action_just_pressed("camera_low"):
		zoom.x += 1
		zoom.y += 1
	
	
	y_input = int(Input.is_action_pressed("camera_down")) - int(Input.is_action_pressed("camera_up"))
	x_input = int(Input.is_action_pressed("camera_right")) - int(Input.is_action_pressed("camera_left"))
	if !GameManager.instance.is_input_mode:
		position += Vector2(x_input,y_input).normalized() * (distance_each_input/zoom.x)
	
