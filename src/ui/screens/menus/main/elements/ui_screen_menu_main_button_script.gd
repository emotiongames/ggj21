extends MarginContainer


export (PackedScene) var destination_scene
export (String) var button_name = ""


func _ready():
	$Button.text = button_name
	set_pause_mode(2)


func _on_Button_button_up():
	$Pressed.play()


func _on_Button_mouse_entered():
	$Focused.play()


func _on_Pressed_finished():
	get_tree().change_scene_to(destination_scene)
