extends MarginContainer


func _on_Button_button_up():
	$Pressed.play()


func _on_Button_mouse_entered():
	$Focused.play()


func _on_Pressed_finished():
	get_tree().change_scene("res://src/ui/screens/menus/main/ui_screens_menu_main.tscn")
