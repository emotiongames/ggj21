extends "../object_item_base_script.gd"


export (float) var recharge_value = 100


func _ready():
	type = "flash_recharge"


func do_action(player):
	var flash_hud = player.get_node(player.flash_hud)
	flash_hud.recharge(recharge_value)
	queue_free()

func _on_FlashRecharge_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_FlashRecharge_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false


func _on_SpawnCollisionArea_area_entered(area):
	if area.is_in_group("item"):
		area.queue_free()
