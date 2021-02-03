extends "puzzle_item_base_script.gd"

func switch_sprites():
	$BeforePhotograph.hide()
	$AfterPhotograph.show()


func _on_BlackboardEraser_area_entered(area):
	._on_PuzzleItemBase_body_entered(area)


func _on_BlackboardEraser_area_exited(area):
	._on_PuzzleItemBase_body_exited(area)
