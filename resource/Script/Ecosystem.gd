extends Node2D

var life_list = []
# Ecosystem attributes
@export var temperature = 25
@export var humidity = 55
var creature_count = 0
var days=0
signal day_end
var action_points = 3
var weather

var initial_plant = false
# UI elements
@onready var temperatureLabel = $TemperatureLabel
@onready var humidityProgressBar = $HumidityProgressBar
@onready var creatureCountLabel = $CreatureCountLabel
@onready var daysLabel = $DaysLabel
@onready var next_day_button = $NextDayButton 
@onready var action_pointsLabel = $Action_pointsLabel
@onready var diary_day = $Sprite2D/Day
@onready var bug_node = $Bug
@onready var flower_node = $flower
@onready var bush_node = $bush
@onready var plant1_node =$plant1
enum PlantType {
  FLOWER,
  BUSH,
  PLANT
}

enum Weather {
  SUNNY, 
  CLOUDY,
  RAINY
}

var selected_plant = PlantType.FLOWER

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
	updateUI()

func next_day():
#	for i in life_list:
#		i.on_next_day()
	emit_signal('day_end')
	updateUI()
#	$Sprite2D.visible = true
	days+=1
	$MistingSystemButton.disabled = false
	$OpenCurtainsButton.disabled = false
	$PlantButton.disabled = false
	$ShovelButton.disabled = false
	if creature_count>=12:
		deleteplant()
#	elif creature_count>=12:
#		creature_count-=2	
	# Update attributes
	weather = Weather.values()[randi() % Weather.size()]
	if weather == Weather.SUNNY:
		temperature += 2
		humidity -= 8
		$Weather.texture = load("res://resource/Art/Background/sunny with birds.PNG")
	elif weather == Weather.CLOUDY:
		humidity -= 4	
		$Weather.texture = load("res://resource/Art/Background/cloudy.png")
	elif weather == Weather.RAINY:
		temperature -= 2
		$Weather.texture = load("res://resource/Art/Background/rainy.png")
	action_points = 3	
	updateUI()
	await get_tree().create_timer(0.2).timeout
	if temperature <14 || temperature > 48:
		game_over()
	if humidity >100 || humidity < 10:
		game_over()
	if days ==1:
		$ShovelButton.visible = true	
	if days == 3:
		$random.visible = true
		$Panel/CheckBox.visible = false
		$Panel/CheckBox4.visible = true
		updateUI()
		if creature_count < 6:	
			game_over()
		else:
			addBug()
	if days ==7:
		updateUI()
		if creature_count < 10 || creature_count >15:
			game_over()
		else:
			pass		
	next_day_button.nextday_end()
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)



func game_over():
	get_tree().change_scene_to_file("res://gameover.tscn")
			
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
		temperature += 4
		print("Curtain button pressed")
		updateUI()
		

func placePlant(type):
	# Increase creature count, humidity, and decrease temperature
	if checkActionPoints():
		addPlant(type)
		print("Plant button pressed")
		updateUI()
	# Update other attributes and game mechanics
	
func placeBug():
	# Increase creature count, humidity, and decrease temperature
	if checkActionPoints():
		addBug()
		print("Bug button pressed")
		updateUI()

func addPlant(type):
	var flower_scene
	var flower_instance
	if type == PlantType.FLOWER:
		flower_scene = load("res://flower.tscn")
		humidity -= 2
		temperature -= 2
		flower_instance = flower_scene.instantiate()
		flower_node.add_child(flower_instance)
	elif type == PlantType.BUSH:
		flower_scene = load("res://bush.tscn")
		humidity -= 1
		temperature -= 3
		flower_instance = flower_scene.instantiate()
		bush_node.add_child(flower_instance)
	elif type == PlantType.PLANT:
		humidity -= 3
		temperature += 1
		flower_scene = load("res://plant1.tscn")
		flower_instance = flower_scene.instantiate()
		plant1_node.add_child(flower_instance)			
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x
		var random_y
		while true:
			random_x = randf_range(450, 770)
			random_y = randf_range(670, 690)
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
		if initial_plant:
			flower_instance.growth = randf_range(0.5,0.7)

		initial_plant = true
		get_tree().get_root().add_child(flower_instance)

	else:
		print("flower_instance is null")
#	get_tree().get_root().add_child(flower_instance)

	# Load the Plant scene and instance it

	# Add the plant instance as a child to the root node or another suitable node
func addBug():
	print("adding bugs")
	var flower_scene = load("res://bugs.tscn")
	var flower_instance = flower_scene.instantiate()
	bug_node.add_child(flower_instance)
	if flower_instance != null:
		print("Successfully instantiated bug_instance")
		var plant_positions = []
		var random_x= randf_range(480, 750)
		var random_y= randf_range(647, 648)
		var new_scale = randf_range(0.5,0.8)
		random_x = clamp(random_x,450,900)
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
		get_tree().get_root().add_child(flower_instance)
	else:
		print("bugr_instance is null")	
		
func deleteplant():
	var allplants = get_tree().get_nodes_in_group("plants")
	if allplants.size() > 0: 
		var index = randi() % allplants.size()
		allplants[index].queue_free()
		updateUI()

func updateUI():
	if action_points<=0:
		$MistingSystemButton.disabled = true
		$OpenCurtainsButton.disabled = true
		$PlantButton.disabled = true
		$BugButton.disabled = true
		$ShovelButton.disabled = true
		$PlantPanel.hide()
		next_day_button.nextday_hint()
	if days<2:
		$BugButton.disabled = true
	if days>2:
		$BugButton.disabled = false	
	temperatureLabel.text = "Temperature: " + str(temperature)
	humidityProgressBar.value = humidity
	creatureCountLabel.text = "Creature Count: " + str(creature_count)
	daysLabel.text= str(days)
	action_pointsLabel.text= str(action_points)
	diary_day.text = "Day: " + str(days)
	if temperature in range(20,30):
		$Panel/CheckBox2.button_pressed = true
	elif temperature >30 || temperature<20:
		$Panel/CheckBox2.button_pressed = false 	
	if humidity in range(70,90):
		$Panel/CheckBox3.button_pressed = true
	elif humidity >90 || humidity < 70:
		$Panel/CheckBox3.button_pressed = false	
	if creature_count > 6:
		$Panel/CheckBox.button_pressed = true
	elif creature_count < 6:
		$Panel/CheckBox.button_pressed = false
	if creature_count in range(10,15):
		$Panel/CheckBox4.button_pressed = true
	elif creature_count >15 || creature_count < 10:		
		$Panel/CheckBox4.button_pressed = false	
		
func checkActionPoints():
	if action_points>0:
		action_points -=1
		print("action remain!")
		return true
	print("no action remain!")	
	return false	


	
func _on_next_day_button_pressed():
	next_day()


func _on_open_curtains_button_pressed():
	openCurtains()


func _on_plant_button_pressed():
	$PlantPanel.visible = !$PlantPanel.visible

func _on_plant_selected(id):
	selected_plant = id

func _on_misting_system_button_pressed():
	activateMistingSystem()


func _on_flower_pressed():
	placePlant(0) # Replace with function body.


func _on_bush_pressed():
	placePlant(1)


func _on_continue_pressed():
	$GuidePanel.visible = false


func _on_plant_1_pressed():
	placePlant(2)


func _on_check_box_ready():
	pass # Replace with function body.


func _on_check_box_2_ready():
	pass # Replace with function body.


func _on_check_box_3_ready():
	pass # Replace with function body.


func _on_day_ready():
	pass # Replace with function body.


func _on_button_pressed():
	$Sprite2D.visible = false;


func _on_bug_button_pressed():
	placeBug()




func _on_dinning_pressed():
	print("dinning!")
	$random/dinning/before.visible = false
	$random/dinning/after.visible = true
	$random/dinning/Label.text = 'Grass - 2'
	$random/kitty.disabled = true
	$random/game.disabled = true
	deleteplant()
	deleteplant()
	$random/finish.disabled = false
	



func _on_kitty_pressed():
	$random/kitty/before.visible = false
	$random/kitty/after.visible = true
	$random/kitty/Label.text = 'Grass + 2'
	$random/dinning.disabled = true
	$random/game.disabled = true
	addPlant(PlantType.FLOWER)
	addPlant(PlantType.BUSH)
	$random/finish.disabled = false


func _on_game_pressed():
	$random/game/before.visible = false
	$random/game/after.visible = true
	$random/game/Label.text = 'Temp + 5'
	$random/dinning.disabled = true
	$random/kitty.disabled = true
	temperature +=5
	$random/finish.disabled = false


func _on_finish_pressed():
	$random.visible = false
	updateUI()


func _on_shovel_button_pressed():
	if checkActionPoints():
		deleteplant()
		updateUI()
