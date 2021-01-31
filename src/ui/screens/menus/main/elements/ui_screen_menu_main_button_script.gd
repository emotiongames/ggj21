extends MarginContainer


export (PackedScene) var destination_scene
export (String) var button_name = ""


func _ready():
	$Button.text = button_name

func _on_Button_button_down():
	get_tree().change_scene_to(destination_scene)
