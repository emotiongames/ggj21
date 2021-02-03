extends "../object_item_base_script.gd"


func _ready():
	type = "razor_blade"


func _process(delta):
	if skill:
		if on_skill_area and skill.active and is_locked:
			skill_hint.play("hide")
			$BehaviorPlayer.play("unlock_to_interact")


func do_action(player):
	if not is_locked:
		.play_audio($GetItemAudio)


func _on_BlackboardEraser_body_entered(body):
	if body.is_in_group("player") and not is_locked:
		is_player_close = true


func _on_BlackboardEraser_body_exited(body):
	if body.is_in_group("player") and not is_locked:
		is_player_close = false


func _on_GetItemAudio_finished():
	$Events/UnlockNextPuzzleItem.play()
	queue_free()


func is_unlocked():
	return not is_locked


func _on_SkillInteractionArea_area_entered(area):
	if area.is_in_group("skill") and is_locked:
		on_skill_area = true
		skill = area
		skill_hint.play("show")


func _on_SkillInteractionArea_area_exited(area):
	if area.is_in_group("skill") and is_locked:
		on_skill_area = false
		skill = null
		skill_hint.play("hide")
