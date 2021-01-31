extends MarginContainer


export (String) var button_name = ""

func _ready():
	$Button.text = button_name
	set_pause_mode(2)


func _on_Button_button_up():
	$Pressed.play()


func _on_Pressed_finished():
	match button_name:
		"Resume":
			Events.emit_signal("resume_game")
		"Restart Level":
			get_tree().paused = false
			get_tree().reload_current_scene()
		"Main Menu":
			get_tree().paused = false
			get_tree().change_scene("res://src/ui/screens/menus/main/ui_screens_menu_main.tscn")
		"Exit Game":
			get_tree().paused = false
			get_tree().change_scene("res://src/ui/screens/exit_game/ui_screen_exit_game.tscn")


func _on_Button_mouse_entered():
	$Focused.play()
