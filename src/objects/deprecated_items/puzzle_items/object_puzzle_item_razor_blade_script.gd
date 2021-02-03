extends "puzzle_item_base_script.gd"


func _ready():
	var _puzzle_unlock_item_signal = Events.connect("puzzle_unlock_item", self, "_on_Puzzle_unlock_item")
	
	if is_item_to_unlock:
		$CollisionShape2D.set_deferred("disabled", true)


func _on_Puzzle_unlock_item(item):
	if item.get_item_name() == .get_item_name():
		# Muda sprite
		$CollisionShape2D.set_deferred("disabled", false)


func _on_RazorBlade_area_entered(area):
	._on_PuzzleItemBase_body_entered(area)


func _on_RazorBlade_area_exited(area):
	._on_PuzzleItemBase_body_exited(area)


func _on_Get_puzzle_item(item):
	if item == item_name:
		Events.emit_signal("spawn_interactive_item", "stair")
		queue_free()
