extends "object_base_event_script.gd"


export (String) var animation_to_play = ""


func _ready():
	var node_animation_finished_signal = node.connect("animation_finished", self, "on_Animation_finished")


func play():
	node.play(animation_to_play)


func on_Animation_finished(animation):
	if animation_to_play == animation:
		is_done = true


func is_playing():
	return node.is_playing()
