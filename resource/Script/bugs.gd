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
	add_to_group("animals")
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
	else:
		temp_growth = -0.2
		#print("temperature is right!")
	if humidity >= 60 and humidity <= 90:
		humid_growth = humidity/75
	else:
		temp_growth = -0.2
			#print("humidity is right!")
			
	#choose plant to eat, if the plant is larger than 1
	var plant = get_tree().get_nodes_in_group("plants")
	if plant.size() != 0:
		var target_plant
		for i in plant:
			if i.growth >= 1:
				target_plant = i
				break
		if target_plant:
			print('eating plant ')
			target_plant.growth = 0.3
			var temp = remap(target_plant.growth,0.1,3,0,1)
			target_plant.scale = Vector2(temp,temp)*scale_modifier
			growth += 1 + temp_growth * humid_growth
		else:
			growth -= 0.5
			if growth < 0:
				queue_free()
	else:
		growth -= 0.5
		if growth < 0:
			queue_free()
		#temporary balance solution
		plant.pick_random().queue_free()
	

func addPlant():
	var flower_scene = load("res://bugs.tscn")
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		#print("Successfully instantiated bug_instance")
		var plant_positions = []
		var random_x= get_global_position().x + randf_range(-220, 220)
		var random_y= get_global_position().y + randf_range(-50, 50)
		var temp = remap(growth,0,2,0.1,1)
		var new_growth = randf_range(0.3,0.6)
		random_x = clamp(random_x,480, 750)
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
		flower_instance.set_global_position(Vector2(random_x, random_y))
		flower_instance.growth = new_growth
		flower_instance.scale_modifier = randf_range(0.2,0.4)
		get_parent().add_child(flower_instance)
	else:
		print("bugr_instance is null")



func on_next_day():
	update_eco()
	days+=1
	calculate_growth()
	await get_tree().create_timer(0.1).timeout
	if growth>=1.5:
		if growth >=2:
			growth = 1
		addPlant()
		var temp = remap(growth,0.5,3,0.5,1)
		scale = Vector2(temp,temp)*scale_modifier
	
#	# Update attributes
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)	

