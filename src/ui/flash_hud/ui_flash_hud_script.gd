extends CenterContainer


var gauge : TextureProgress


func _ready():
	gauge = $MarginContainer/HBoxContainer/ProgressBarContainer/CenterContainer/Gauge

func _process(delta):
	if gauge.value < 100 and $GaugeRecoveryTimer.is_stopped():
		$GaugeRecoveryTimer.start()
	pass


func _on_GaugeRecoveryTimer_timeout():
	gauge.value += 2.5


func can_reduce_gauge(value):
	if gauge.value >= value:
		gauge.value -= value
		return true
	else:
		return false


func recharge(value):
	gauge.value += value
