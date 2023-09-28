extends Sprite2D

var humidity
var temperature
var growth = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func placePlant():
	# Increase creature count, humidity, and decrease temperature
	addPlant()
	print("Plant button pressed")


func addPlant():
	var flower_scene = load("res://scenes/new folder/flower.tscn")
	var flower_instance = flower_scene.instantiate() as Sprite2D
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x
		var random_y
		while true:
			random_x = randf_range(345, 600)
			random_y = randf_range(360, 380)
			var overlapping = false
			# Check for overlap with existing plant positions
			for existing_position in plant_positions:
				var distance = plant_positions.distance_to(existing_position)
				if distance < 2:
					overlapping = true
					break
			if not overlapping:
				plant_positions.append(Vector2(random_x, random_y))
				break
#		# Generate random coordinates for the plant's position
#		var random_x = randf_range(345, 600)  # Adjust the range as needed
#		var random_y = randf_range(360, 380)  # Adjust the range as needed
#		# Set the plant's position
		flower_instance.position = Vector2(random_x, random_y)
		get_tree().get_root().add_child(flower_instance)
	else:
		print("flower_instance is null")
#	get_tree().get_root().add_child(flower_instance)

	# Load the Plant scene and instance it

	# Add the plant instance as a child to the root node or another suitable node
func on_next_day():
	days+=1
	var growth =0
	if temperature>=24 and temperature <=32:
		var temp_growth = temperature -24
		print("temperature is right!")
		if humidity >= 60 and humidity <= 90:
			var humid_growth = humidity - 60
			print("humidity is right!")
			growth = temp_growth * humid_growth * creature_count		
	if growth>=1:
		creature_count += 1
		growth=0
		addPlant()
	
	# Update attributes
	temperature = randf_range(temperature-2, temperature+2)		
	humidity = randf_range(humidity-10, humidity+10)	
	
	updateUI()
