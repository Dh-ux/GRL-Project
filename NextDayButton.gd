extends Button



@export var spring: float = 600.0
@export var damp: float = 20.0


var displacement: float = 0.0 
var velocity: float = 0.0

func _process(delta):
	if velocity != 0:
		var force = -spring * displacement - damp * velocity
		velocity += force * delta
		displacement += velocity * delta
		$Sprite2D.rotation = -displacement





var saved_scale
# Called when the node enters the scene tree for the first time.
func _ready():
	saved_scale = scale
	randomize()

func nextday_hint():
	$Sprite2D/hint.show()
	$Timer.start()
	
func nextday_end():
	$Sprite2D/hint.hide()
	$Timer.stop()

func _on_mouse_entered():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(1)
	tween.tween_property(self, "scale", saved_scale*1.1, 0.1)


func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", saved_scale, 0.1)


func _on_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", scale*0.9, 0.06)
	await tween.finished
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "scale", scale/0.9, 0.06)


func _on_timer_timeout():
	velocity = 30
