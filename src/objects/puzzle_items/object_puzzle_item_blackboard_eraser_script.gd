extends "puzzle_item_base_script.gd"

func switch_sprites():
	$BeforePhotograph.hide()
	$AfterPhotograph.show()


func _on_BlackboardEraser_body_entered(body):
	._on_PuzzleItemBase_body_entered(body)


func _on_BlackboardEraser_body_exited(body):
	._on_PuzzleItemBase_body_exited(body)
