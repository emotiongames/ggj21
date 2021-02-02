extends "../object_item_base_script.gd"


var is_player_close = false


func _ready():
	type = "camera"


func do_action(player):
	var skill = scene_to_unlock.instance()
	player.get_node("Skills").add_child(skill)
	player.get_node("InputSkill").set_skill(skill.SkillState.WEAK)
	#Events.emit_signal("spawn_interactive_item", "stair")
	queue_free()


func _on_CameraItem_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_CameraItem_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false
