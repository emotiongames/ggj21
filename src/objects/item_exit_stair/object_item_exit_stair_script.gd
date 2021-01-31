extends Area2D


export (PackedScene) var next_game_scene

var is_spawned = false


func _ready():
	var  _go_to_next_scene_signal = Events.connect("go_to_next_scene", self, "_on_Go_to_next_scene")
	var  _spawn_interactive_item_signal = Events.connect("spawn_interactive_item", self, "_on_Spawn_interactive_item")
	add_to_group("exit_stair")


func _on_Go_to_next_scene():
	if is_spawned:
		get_tree().change_scene_to(next_game_scene)


func _on_ExitStair_area_entered(area):
	if area.is_in_group("player") and is_spawned:
		Events.emit_signal("ui_show_interaction_hint", true)


func _on_ExitStair_area_exited(area):
	if area.is_in_group("player") and is_spawned:
		Events.emit_signal("ui_show_interaction_hint", false)


func _on_Spawn_interactive_item(item):
	if item == "stair":
		if not is_spawned:
			is_spawned = true
			show()
