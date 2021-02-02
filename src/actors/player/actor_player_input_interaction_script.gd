extends Node2D


var is_available_to_interact : bool = false
var player
var item

func _ready():
	player = get_parent()


func _process(delta):
	interact()


func interact():
	if Input.is_action_just_released("player_interaction") and item:
		item.do_action(player)


func _on_InteractionArea_area_entered(area):
	if area.is_in_group("item"):
		item = area
		Events.emit_signal("ui_show_interaction_hint", true)


func _on_InteractionArea_area_exited(area):
	if area.is_in_group("item"):
		item = null
		Events.emit_signal("ui_show_interaction_hint", false)
