extends Area2D


export (String) var item_name = ""
export (NodePath) var unlock_item
export (bool) var is_item_to_unlock = false
export (bool) var require_flash_light = false

var item_to_unlock = null
var was_photographed = false
var is_player_on_area = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var _get_puzzle_item_signal = Events.connect("get_puzzle_item", self, "_on_Get_puzzle_item")
	var _puzzle_item_photographed_signal = Events.connect("puzzle_item_photographed", self, "_on_Puzzle_item_photographed")
	
	if unlock_item:
		item_to_unlock = get_node(unlock_item)
	
	add_to_group("puzzle_item")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_item_name():
	return item_name


func is_flash_light_required():
	return require_flash_light


func was_item_photographed():
	return was_photographed


func _on_Get_puzzle_item(item):
	if item == item_name:
		if require_flash_light:
			if was_photographed:
				if item_to_unlock:
					Events.emit_signal("puzzle_unlock_item", item_to_unlock)
				queue_free()
		else:
			if item_to_unlock:
				Events.emit_signal("puzzle_unlock_item", item_to_unlock)
			queue_free()


func _on_Puzzle_item_photographed(item):
	if item == item_name:
		was_photographed = true
		Events.emit_signal("ui_show_skill_use_required_hint", false)
		if is_player_on_area:
			Events.emit_signal("ui_show_interaction_hint", true)
		switch_sprites()


func switch_sprites():
	print("Needs to overload this function")


func _on_PuzzleItemBase_body_entered(body):
	if body.is_in_group("player"):
		if require_flash_light and not was_photographed:
			Events.emit_signal("ui_show_skill_use_required_hint", true)
		else:
			Events.emit_signal("ui_show_interaction_hint", true)
		is_player_on_area = true


func _on_PuzzleItemBase_body_exited(body):
	if body.is_in_group("player"):
		Events.emit_signal("ui_show_skill_use_required_hint", false)
		Events.emit_signal("ui_show_interaction_hint", false)
		is_player_on_area = false
