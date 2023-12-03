extends Button

var saved_scale
# Called when the node enters the scene tree for the first time.
func _ready():
	saved_scale = scale



func _on_mouse_entered():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(1)
	tween.tween_property(self, "scale", saved_scale*1.1, 0.1)


func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", saved_scale, 0.1)


func _on_pressed():
	pass
