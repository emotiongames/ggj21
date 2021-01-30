extends Area2D


func _ready():
	var  _get_skill_signal = Events.connect("get_skill", self, "_on_Get_skill")
	add_to_group("skill")


func _on_Get_skill():
	queue_free()

func _on_PowerfulFlash_body_entered(body):
	if body.is_in_group("player"):
		Events.emit_signal("ui_show_interaction_hint", true)


func _on_PowerfulFlash_body_exited(body):
	if body.is_in_group("player"):
		Events.emit_signal("ui_show_interaction_hint", false)
