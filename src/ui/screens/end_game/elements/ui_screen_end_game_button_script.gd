extends MarginContainer


export (String) var button_name = ""


func _ready():
	$Button.text = button_name
	set_pause_mode(2)


func _on_Button_button_up():
	$Pressed.play()


func _on_Pressed_finished():
	match button_name:
		"Restart Game":
			get_tree().change_scene("res://src/levels/prototype_level_1/level_prototype_level_1.tscn")
		"Main Menu":
			get_tree().change_scene("res://src/ui/screens/menus/main/ui_screens_menu_main.tscn")


func _on_Button_mouse_entered():
	$Focused.play()
