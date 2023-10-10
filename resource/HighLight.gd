extends Button




func _on_mouse_entered():
	var h = get_node("hint")
	if h and not disabled:
		$hint.show()


func _on_mouse_exited():
	var h = get_node("hint")
	if h and not disabled:
		$hint.hide()


func _on_pressed():
	var h = get_node("hint")
	if h:
		var tween = get_tree().create_tween()
		tween.tween_property(h, "scale", h.scale*0.95, 0.05)
		await tween.finished
		var tween1 = get_tree().create_tween()
		tween1.tween_property(h, "scale", h.scale/0.95, 0.05)
