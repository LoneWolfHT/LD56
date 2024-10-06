extends Panel

func _on_button_pressed():
	get_tree().paused = false

	self.visible = false
