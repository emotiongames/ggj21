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
		$Events/ShowInteractionHint.play()
	if area.is_in_group("puzzle_item"):
		if area.is_unlocked():
			item = area
			$Events/ShowInteractionHint.play()


func _on_InteractionArea_area_exited(area):
	if area.is_in_group("item") or area.is_in_group("puzzle_item"):
		item = null
		$Events/HideInteractionHint.play()
