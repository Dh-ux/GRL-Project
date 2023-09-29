extends Node2D

var life_list = []
# Ecosystem attributes
@export var temperature = 25
@export var humidity = 50
var creature_count = 0
var days=0
signal day_end
var action_points = 3

# UI elements
@onready var temperatureLabel = $TemperatureLabel
@onready var humidityProgressBar = $HumidityProgressBar
@onready var creatureCountLabel = $CreatureCountLabel
@onready var daysLabel = $DaysLabel
@onready var next_day_button = $NextDayButton 
@onready var action_pointsLabel = $Action_pointsLabel

func _ready():
	# Initialize UI
	updateUI()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		next_day()


func register(object):
	#if object.type == 0
	creature_count+=1
	object.tree_exited.connect(unregister)
	updateUI()
	
func unregister(type = 0):
	creature_count-=1

func next_day():
#	for i in life_list:
#		i.on_next_day()
	emit_signal('day_end')
	days+=1
	$MistingSystemButton.disabled = false
	$OpenCurtainsButton.disabled = false
	$PlantButton.disabled = false
	# Update attributes
	temperature = randf_range(temperature-2, temperature+2)		
	humidity = randf_range(humidity-10, humidity+10)
	action_points = 3	
	
	updateUI()
			
func activateMistingSystem():
	# Increase humidity
	if checkActionPoints():
		humidity += 10
		print("Misting button pressed")
		updateUI()

	# Update other attributes and game mechanics

func openCurtains():
	# Increase sunlight and temperature
	if checkActionPoints():
		temperature += 5
		print("Curtain button pressed")
		updateUI()

	# Update other attributes and game mechanics

func placePlant():
	# Increase creature count, humidity, and decrease temperature
	if checkActionPoints():
		humidity += 5
		temperature -= 2
		addPlant()
		print("Plant button pressed")
		updateUI()
	# Update other attributes and game mechanics

func addPlant():
	var flower_scene = load("res://flower.tscn")
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x
		var random_y
		while true:
			random_x = randf_range(395, 550)
			random_y = randf_range(380, 400)
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


func updateUI():
	if action_points<=0:
		$MistingSystemButton.disabled = true
		$OpenCurtainsButton.disabled = true
		$PlantButton.disabled = true
	temperatureLabel.text = "Temperature: " + str(temperature)
	humidityProgressBar.value = humidity
	creatureCountLabel.text = "Creature Count: " + str(creature_count)
	daysLabel.text="Days: " + str(days)
	action_pointsLabel.text="Action points Left: " +str(action_points)
		
func checkActionPoints():
	if action_points>0:
		action_points -=1
		print("action remain!")
		return true
	print("no action remain!")	
	return false	


	
func _on_next_day_button_pressed():
	next_day()

func _on_creature_count_label_ready():
	pass # Replace with function body.


func _on_temperature_label_ready():
	pass # Replace with function body.


func _on_humidity_progress_bar_ready():
	pass # Replace with function body.


func _on_humidity_progress_bar_property_list_changed():
	pass # Replace with function body.


func _on_humidity_progress_bar_changed():
	pass # Replace with function body.


func _on_days_label_ready():
	pass # Replace with function body.


func _on_action_points_label_ready():
	pass # Replace with function body.


func _on_open_curtains_button_pressed():
	openCurtains()


func _on_plant_button_pressed():
	placePlant()


func _on_misting_system_button_pressed():
	activateMistingSystem()
