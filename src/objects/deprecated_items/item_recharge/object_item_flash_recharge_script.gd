extends Area2D

export (int) var recharge_value = 100

func _ready():
	var _get_flash_recharge_item_signal = Events.connect("get_flash_recharge_item", self, "_on_Get_flash_recharge_item")
	add_to_group("flash_recharge_item")
	$RechargeSpawnCollision.add_to_group("spawn_collision")


func _on_Get_flash_recharge_item(recharge):
	if self == recharge:
		Events.emit_signal("ui_add_flash_gauge_value", recharge_value)
		queue_free()


func _on_FlashRecharge_area_entered(area):
	if area.is_in_group("player"):
		Events.emit_signal("ui_show_interaction_hint", true)


func _on_FlashRecharge_area_exited(area):
	if area.is_in_group("player"):
		Events.emit_signal("ui_show_interaction_hint", false)


func _on_RechargeSpawnCollision_area_entered(area):
	if area.is_in_group("spawn_collision"):
		print("recharge_collision_detected")
		queue_free()
