extends "../object_item_base_script.gd"


func _ready():
	type = "powerful_flash"


func do_action(player):
	get_tree().paused = true
	var skill = PlayerSkills.get_node("CameraFlash")
	print(skill.get_available_states())
	skill.unlock_state(skill.SkillState.STRONG)
	print(skill.get_available_states())
	#player.get_node("InputSkill").set_skill(skill.SkillState.WEAK)
	$Events/ShowSkillHint.play()
	queue_free()

func _on_PowerfulFlash_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_PowerfulFlash_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false
