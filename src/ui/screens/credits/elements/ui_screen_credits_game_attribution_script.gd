extends MarginContainer


export (String) var attribution_text  = ""


func _ready():
	$CenterContainer/Label.text = attribution_text
