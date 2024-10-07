extends GameObject

class_name Citizen

var sprite: Sprite2D
var click_detection: Area2D

var reproductive_age: int = 6
var movable_age: int = 2
var life_expectancy: int = 80 

var on_hover: bool = false

var first_name: String
var family_name : String
var family: Family
var age: int
var birth_tick: int
var speed: float = 2
var birth_date: String
var gender: String
var is_pregnant: bool = false
var is_alive: bool = true
var death_tick: int

var father: Citizen
var mother: Citizen
var spouse: Citizen
var children: Array[Citizen]

var interact_radius: int = 8
var visible_radius: int = 40
var citizens_in_interact_radius: Array[Citizen]
var citizens_in_visible_radius: Array[Citizen] 

var last_behavior: Behavior
var current_behavior: Behavior

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/small_unit.png")
	add_child(sprite)
	
	click_detection = Area2D.new()
	click_detection.monitoring = true
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(4,4)
	collision_shape.shape = rect_shape
	add_child(click_detection)
	click_detection.add_child(collision_shape)
	click_detection.input_pickable = true
	click_detection.collision_layer = 1
	click_detection.priority = 1
	click_detection.mouse_entered.connect(_on_click_detection_mouse_entered)
	click_detection.mouse_exited.connect(_on_click_detection_mouse_exited)
	sprite.modulate = family.family_color
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_hover and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !GameManager.instance.is_input_mode:
		Inspector.instance.current_inspection = self
		Inspector.instance.update_inspector_display()

func _init(_family: Family, _gender: String, _birth_tick: int = GameManager.instance.current_tick) -> void:
	family = _family
	family_name = family.family_name
	if _gender == "random":
		match randi() % 2:
			0:
				gender = "male"
			1: 
				gender = "female"
	else:
		gender = _gender
	first_name = Population.instance.generate_first_name(gender)
	age = 0
	birth_tick = _birth_tick
	birth_date = GameManager.instance.convert_tick_to_date(birth_tick)
	make_decision()

func tick() -> void:
	if is_alive:
		if randi()%100 <= 100 - (life_expectancy - age)*2 and age>=40:
			die()
		
		if age >= reproductive_age and family.family_members.size() >= 20:
			if randi()%100 <= 5:
				family = Population.instance.create_new_family()
				family.family_members.append(self)
				family_name = family.family_name
				sprite.modulate = family.family_color
		citizens_in_interact_radius = interact_detect()
		citizens_in_visible_radius = visible_detect()
		if current_behavior._tick():
			last_behavior = current_behavior
			current_behavior._end()
			if !is_pregnant:
				make_decision()
		age = (GameManager.instance.current_tick - birth_tick) / GameManager.instance.year_length
		if age < 0:
			age = 0
	else:
		if GameManager.instance.current_tick - death_tick > 365:
			queue_free()

func make_decision() -> void:
	if age >= reproductive_age and !is_pregnant:
		for citizen in citizens_in_interact_radius:
			if citizen.age >= reproductive_age and !citizen.is_pregnant and gender!=citizen.gender:
				if gender=="male":
					current_behavior = Sex.new(self,citizen)
					citizen.current_behavior = Sex.new(self,citizen)
					return
				elif gender=="female":
					current_behavior = Sex.new(citizen,self)
					citizen.current_behavior = Sex.new(citizen,self)
					return
		for citizen in citizens_in_visible_radius:
			if citizen.age >= reproductive_age and !citizen.is_pregnant and gender!=citizen.gender:
				current_behavior = GoTo.new(self, citizen.position, speed)
	
	if age >= movable_age and last_behavior is not GoTo:
		randomize()
		var destination = position + Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * randf_range(5,10)
		if destination.x < 0-GameManager.instance.area_width/2:
			destination.x = 0-GameManager.instance.area_width/2
		elif destination.x > 0+GameManager.instance.area_width/2:
			destination.x = 0+GameManager.instance.area_width/2
			
		if destination.y < 0-GameManager.instance.area_height/2:
			destination.y = 0-GameManager.instance.area_height/2
		elif destination.y > 0+GameManager.instance.area_height/2:
			destination.y = 0+GameManager.instance.area_height/2
			
		current_behavior = GoTo.new(self, destination, speed)
		return
	if last_behavior is GoTo:
		current_behavior = Waiting.new(randi_range(1,20))
		return
	else:
		current_behavior = Waiting.new(randi_range(1,20))
		return
	

func interact_detect() -> Array[Citizen]:
	var temp: Array[Citizen];
	for citizen in Population.instance.get_children():
		if position.distance_to(citizen.position) <= interact_radius:
			temp.append(citizen)
	return temp
			
	
func visible_detect() -> Array[Citizen]:
	var temp: Array[Citizen];
	for citizen in Population.instance.get_children():
		if position.distance_to(citizen.position) <= visible_radius:
			temp.append(citizen)
	return temp
	
func die() -> void:
	is_alive = false
	sprite.modulate = Color(Color.WHITE,0.5)
	Population.instance.total_population -= 1
	death_tick = GameManager.instance.current_tick
	current_behavior = Dead.new(GameManager.instance.convert_tick_to_date(GameManager.instance.current_tick))

func _on_click_detection_mouse_entered() -> void:
	on_hover = true

func _on_click_detection_mouse_exited() -> void:
	on_hover = false
