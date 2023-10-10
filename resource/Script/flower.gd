extends Sprite2D

var eco_system
var humidity
var temperature

@export var base_growth_per_day = 0.5
@export var humidity_target = 75
@export var humidity_range = 15
@export var temp_target = 27
@export var temp_range = 6

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
	var temp = remap(growth,0.1,3,0.4,1)
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
	
	var d = abs(temperature - temp_target) - temp_range
	#if the temperature is in range
	if d<=0:
		temp_growth = 0.2 + abs(d/temp_range)
	else:
		#clamp(input; 与理想区间相差1倍时的最高惩罚; 当温度差==适宜温度时的保底生长)
		#print("temp = "+str(-(abs(d/temp_range) -1)))
		temp_growth = clamp(-(abs(d/temp_range) -1),-0.6,0)
		if abs(d/temp_range) > 3:
			humid_growth *= 0.1

	var dh = abs(humidity - humidity_target) - humidity_range
	#for humidity
	if dh<=0:
		humid_growth = 0.2 + abs(dh/humidity_range)
	else:
		#print("hum = "+str(-(abs(dh/humidity_range) -1)))
		humid_growth = clamp(-(abs(dh/humidity_range) -1),-0.5,0)
		if abs(dh/humidity_range) > 4:
			temp_growth *= 0.1
	if abs(d/temp_range) > 3:
		humid_growth *= 0.1
	print("temp = "+str(temp_growth))
	print("hum = "+str(humid_growth))
	growth += (temp_growth + humid_growth)/2 * base_growth_per_day
#	print(growth)
#	var tempa = remap(growth,0,2,0.1,1)
#	scale = Vector2(tempa,tempa)*scale_modifier
	if growth < 0.1:
		queue_free()
		
func addPlant():
	var flower_scene = load("res://flower.tscn")
	var flower_instance = flower_scene.instantiate()
	if flower_instance != null:
		print("Successfully instantiated flower_instance")
		var plant_positions = []
		var random_x= get_global_position().x + randf_range(120, -120)
		var random_y= get_global_position().y
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
		flower_instance.scale_modifier = randf_range(0.7,1)
		get_parent().add_child(flower_instance)
	else:
		print("flower_instance is null")


func on_next_day():
	update_eco()
	days+=1
	calculate_growth()
	#connect the finish day signal
	if growth>=1:
		if growth >=2:
			growth = 2
		addPlant()
		growth -= 0.5
		var temp = remap(growth,0.5,3,0.5,1)
	if growth < 0.1:
		queue_free()
	
#	# Update attributes
#	temperature = randf_range(temperature-2, temperature+2)		
#	humidity = randf_range(humidity-10, humidity+10)	

