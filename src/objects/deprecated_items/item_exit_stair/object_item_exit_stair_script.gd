extends Area2D


export (PackedScene) var next_game_scene

var is_spawned = false


func _ready():
	var  _go_to_next_scene_signal = Events.connect("go_to_next_scene", self, "_on_Go_to_next_scene")
	add_to_group("exit_stair")


func _on_Go_to_next_scene():
	if self.show():
		get_tree().change_scene_to(next_game_scene)


func _on_ExitStair_area_entered(area):
	if area.is_in_group("player") and self.show():
		Events.emit_signal("ui_show_interaction_hint", true)


func _on_ExitStair_area_exited(area):
	if area.is_in_group("player") and self.show():
		Events.emit_signal("ui_show_interaction_hint", false)

