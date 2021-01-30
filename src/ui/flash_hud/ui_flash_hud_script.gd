extends CenterContainer


var gauge : TextureProgress
var is_first_use = true


func _ready():
	var _ui_update_flash_gauge_signal = Events.connect("ui_update_flash_gauge", self, "_on_Ui_update_flash_gauge")
	var _ui_set_flash_gauge_value_signal = Events.connect("ui_set_flash_gauge_value", self, "_on_Ui_set_flash_gauge_value")
	var  _ui_hide_skill_hint_signal = Events.connect("ui_hide_skill_hint", self, "_on_Ui_hide_skill_hint")
	gauge = $MarginContainer/HBoxContainer/ProgressBarContainer/CenterContainer/Gauge

func _process(delta):
	if gauge.value < 100 and $GaugeRecoveryTimer.is_stopped():
		$GaugeRecoveryTimer.start()
	pass


func _on_GaugeRecoveryTimer_timeout():
	gauge.value += 2.5
	Events.emit_signal("ui_flash_gauge_updated", gauge.value)


func _on_Ui_update_flash_gauge(value):
	if not is_first_use:
		gauge.value -= value
		Events.emit_signal("ui_flash_gauge_updated", gauge.value)


func _on_Ui_hide_skill_hint():
	if is_first_use:
		is_first_use = false
	self.show()


func _on_Ui_set_flash_gauge_value(value):
	gauge.value = value
	Events.emit_signal("ui_flash_gauge_updated", gauge.value)
