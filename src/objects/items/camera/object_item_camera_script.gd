extends "../object_item_base_script.gd"


func _ready():
	type = "camera"


func do_action(player):
	get_tree().paused = true
	var skill = scene_to_unlock.instance()
	PlayerSkills.add_child(skill)
	player.get_node("InputSkill").set_skill("CameraFlash")
	$Events/ShowSkillHint.play()
	queue_free()


func _on_CameraItem_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_CameraItem_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false
