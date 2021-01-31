extends MarginContainer

export (Texture) var perfil_image
export (String) var set_name_value
export (String) var set_status_value
export (String) var set_attribution_value


func _ready():
	$VBoxContainer/CenterContainer2/MarginContainer/CenterContainer/TextureRect.texture = perfil_image
	$VBoxContainer/CenterContainer/VBoxContainer/NameText/HBoxContainer/MarginContainer/ValueText.text = set_name_value
	$VBoxContainer/CenterContainer/VBoxContainer/StatusText/HBoxContainer/MarginContainer/ValueText.text = set_status_value
	$VBoxContainer/CenterContainer/VBoxContainer/GameAttribution/CenterContainer/Label.text = set_attribution_value
