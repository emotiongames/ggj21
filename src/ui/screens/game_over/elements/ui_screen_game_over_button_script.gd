extends MarginContainer


#export (PackedScene) var destination_scene
export (String) var button_name = ""


func _ready():
	$Button.text = button_name
	set_pause_mode(2)


func _on_Button_button_up():
	$Pressed.play()


func _on_Button_mouse_entered():
	$Focused.play()


func _on_Pressed_finished():
	if button_name == "Main Menu":
		get_tree().change_scene("res://src/ui/screens/menus/main/ui_screens_menu_main.tscn")
	else:
		get_tree().reload_current_scene()
