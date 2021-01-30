extends CenterContainer

func _ready():
	var  _ui_hide_skill_hint_signal = Events.connect("ui_hide_skill_hint", self, "_on_Ui_hide_skill_hint")
	var  _ui_simple_skill_hint_signal = Events.connect("ui_simple_skill_hint", self, "_on_Ui_simple_skill_hint")
	var  _ui_complete_skill_hint_signal = Events.connect("ui_complete_skill_hint", self, "_on_Ui_complete_skill_hint")


func _on_Ui_simple_skill_hint():
	$Label.text = "You got a camera!\n\nPress mouse LB to take a pic."
	self.show()


func _on_Ui_complete_skill_hint():
	$Label.text = "You got a powerfull camera flash!\n\nHold and release mouse LB to use it."
	self.show()


func _on_Ui_hide_skill_hint():
	self.hide()
