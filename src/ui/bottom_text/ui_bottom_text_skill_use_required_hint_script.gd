extends CenterContainer


func _ready():
	var _ui_show_skill_use_required_hint_signal = Events.connect("ui_show_skill_use_required_hint", self, "_on_Ui_show_skill_use_required_hint")


func _on_Ui_show_skill_use_required_hint(to_show):
	if to_show:
		self.show()
	else:
		self.hide()
