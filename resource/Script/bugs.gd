extends Sprite2D

var eco_system
var humidity
var temperature

var type
var growth = 1
var days =0

var scale_modifier = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	eco_system = get_tree().get_root().get_node('Ecosystem')
	eco_system.register(self)
	eco_system.day_end.connect(on_next_day)
	update_eco()

func _process(delta):
	pass

func update_eco():
	humidity = eco_system.humidity
	temperature = eco_system.temperature

#here goes the main algorithm
func calculate_growth():
	var temp_growth = 0.5
	var humid_growth = 0.5
	if temperature>=24 and temperature <=32:
		temp_growth = temperature/28
		#print("temperature is right!")
		if humidity >= 60 and humidity <= 90:
			humid_growth = humidity/75
			#print("humidity is right!")
	growth += temp_growth * humid_growth	
	

func addPlant():
	var flower_scene = load("res://bugs.tscn")
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x= get_position().x + randf_range(120, -120)
		var random_y= get_position().y + randf_range(20, -20)
		var new_scale = randf_range(0.6,1)
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
		flower_instance.growth = new_scale
		flower_instance.scale_modifier = randf_range(0.7,1)
		get_parent().add_child(flower_instance)
	else:
		print("flower_instance is null")



func on_next_day():
	update_eco()
	days+=1
	calculate_growth()
	await get_tree().create_timer(1).timeout
	if growth>=1:
		if growth >=3:
			growth = 3
		addPlant()
		var temp = remap(growth,0.5,3,0.5,1)
		scale = Vector2(temp,temp)*scale_modifier
	
#	# Update attributes
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)	

