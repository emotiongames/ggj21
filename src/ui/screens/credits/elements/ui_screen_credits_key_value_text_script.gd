extends MarginContainer


export (String) var key_text = ""


func _ready():
	$HBoxContainer/KeyText.text = key_text
