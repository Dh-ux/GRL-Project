extends Sprite2D

var eco_system
var humidity
var temperature
var growth = 0.5
var days =0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func update_eco():
	humidity = 60
	temperature = 25


func addPlant():
	var flower_scene = load('res://resource/flower.tscn')
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x= get_position().x + randf_range(100, -100)
		var random_y= get_position().y + randf_range(20, -20)
		var new_scale = randf_range(0.8,1)
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
		flower_instance.scale = new_scale
		get_parent().add_child(flower_instance)
	else:
		print("flower_instance is null")


func on_next_day():
	update_eco()
	days+=1
	#here goes the main algorithm
	if temperature>=24 and temperature <=32:
		var temp_growth = temperature/28
		print("temperature is right!")
		if humidity >= 60 and humidity <= 90:
			var humid_growth = humidity/75
			print("humidity is right!")
			growth += temp_growth * humid_growth	
	if growth>=1:
		growth=0
		addPlant()
	
#	# Update attributes
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)	

