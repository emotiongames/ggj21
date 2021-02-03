extends "../object_item_base_script.gd"


func _ready():
	type = "exit_stair"


func do_action(_player):
	get_tree().change_scene_to(scene_to_unlock)


func _on_ExitStair_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_ExitStair_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false
