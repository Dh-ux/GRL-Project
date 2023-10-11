extends Node2D

var eco_system
var humidity
var temperature

@export var base_growth_per_day = 0.5
@export var humidity_target = 75
@export var humidity_range = 15
@export var temp_target = 75
@export var temp_range = 15

var type
var growth = 1
var days =0

var scale_modifier = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	eco_system = get_tree().get_root().get_node('Ecosystem')
	eco_system.register(self)
	eco_system.day_end.connect(on_next_day)
	add_to_group("plants")
	update_eco()
	var temp = remap(growth,0.1,3,0.9,1)
	scale = Vector2.ZERO
	#scale = Vector2(temp,temp)*scale_modifier
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(1)
	tween.tween_property(self, "scale", Vector2(temp,temp)*scale_modifier, 0.1)

func _process(delta):
	pass

func update_eco():
	humidity = eco_system.humidity
	temperature = eco_system.temperature

#here goes the main algorithm
func calculate_growth():
	var temp_growth = 0.2
	var humid_growth = 0.2
	if temperature>=24 and temperature <=32:
		temp_growth = temperature/28 * 0.5
		#print("temperature is right!")
		if humidity >= 60 and humidity <= 90:
			humid_growth = humidity/75 * 0.5
			#print("humidity is right!")
	growth += (temp_growth + humid_growth) * base_growth_per_day
	

func addPlant():
	var flower_scene = load("res://plant1.tscn")
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x= get_global_position().x + randf_range(60, 120) * ((randi_range(0,1))*2.0-1)
		var random_y= get_position().y + randf_range(1, -1)
		var new_growth = randf_range(0.3,0.6)
		random_x = clamp(random_x,345,600)
#		while true:
#			random_x = randf_range(345, 600)
#			random_y = randf_range(360, 380)
#			var overlapping = false
#			# Check for overlap with existing plant positions
#			for existing_position in plant_positions:
#				var distance = plant_positions.distance_to(existing_position)
#				if distance < 2:
#					overlapping = true
#					break
#			if not overlapping:
#				plant_positions.append(Vector2(random_x, random_y))
#				break
#		# Generate random coordinates for the plant's position
#		var random_x = randf_range(345, 600)  # Adjust the range as needed
#		var random_y = randf_range(360, 380)  # Adjust the range as needed
#		# Set the plant's position
		flower_instance.position = Vector2(random_x, random_y)
		flower_instance.growth = new_growth
#		flower_instance.scale_modifier = randf_range(0.7,1)
		get_parent().add_child(flower_instance)
	else:
		print("flower_instance is null")


func on_next_day():
	update_eco()
	days+=1
	calculate_growth()
	#connect the finish day signal
	await get_tree().create_timer(0.1).timeout
	if growth>=1:
		if growth >=2:
			growth = 2
		addPlant()
		growth -= 0.5
	var temp = remap(growth,0.1,3,0.9,1)
	scale = Vector2(temp,temp)*scale_modifier
	
#	# Update attributes
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)	

