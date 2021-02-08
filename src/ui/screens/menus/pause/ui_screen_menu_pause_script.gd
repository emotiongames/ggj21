extends Control

func _on_Button_button_up():
	get_tree().paused = false
	queue_free()
