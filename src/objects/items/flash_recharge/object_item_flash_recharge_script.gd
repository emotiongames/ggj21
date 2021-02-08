extends "../object_item_base_script.gd"


export (float) var recharge_value = 100

var instanced_spawn_point


func _ready():
	type = "flash_recharge"


func do_action(player):
	var flash_hud = player.get_node(player.flash_hud)
	flash_hud.recharge(recharge_value)
	instanced_spawn_point.hide()
	queue_free()

func set_spawn_point(spawn_point):
	instanced_spawn_point = spawn_point

func _on_FlashRecharge_body_entered(body):
	if body.is_in_group("player"):
		is_player_close = true


func _on_FlashRecharge_body_exited(body):
	if body.is_in_group("player"):
		is_player_close = false


func _on_SpawnCollisionArea_area_entered(area):
	if area.is_in_group("item"):
		print('collision detected')
		instanced_spawn_point.hide()
		area.queue_free()
